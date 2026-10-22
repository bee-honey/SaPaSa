import Foundation

enum ContentConfig {
    /// Where the app looks for content. Push `manifest.json` to this repo's main branch.
    static let manifestURL = URL(string: "https://raw.githubusercontent.com/bee-honey/sapasa-content/main/manifest.json")!
}

/// On-device locations. Everything lives in Application Support (which iOS does not purge)
/// and is excluded from iCloud backup because it can always be downloaded again.
enum ContentStorage {
    static var rootURL: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SaPaSaContent", isDirectory: true)
        ensureDirectory(url)
        return url
    }

    static var libraryURL: URL {
        rootURL.appendingPathComponent("library.json")
    }

    static var mediaURL: URL {
        let url = rootURL.appendingPathComponent("Media", isDirectory: true)
        ensureDirectory(url)
        return url
    }

    static func mediaFileURL(relativePath: String) -> URL {
        mediaURL.appendingPathComponent(relativePath)
    }

    private static func ensureDirectory(_ url: URL) {
        guard !FileManager.default.fileExists(atPath: url.path) else { return }
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        var mutableURL = url
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try? mutableURL.setResourceValues(values)
    }
}

struct SyncSummary {
    var added = 0
    var updated = 0
    var removed = 0

    var message: String {
        if added == 0 && updated == 0 && removed == 0 {
            return "Library is up to date."
        }
        var parts: [String] = []
        if added > 0 { parts.append("\(added) new") }
        if updated > 0 { parts.append("\(updated) updated") }
        if removed > 0 { parts.append("\(removed) removed") }
        return "Library refreshed: " + parts.joined(separator: ", ") + "."
    }
}

enum ContentSyncError: LocalizedError {
    case badResponse(URL, Int)

    var errorDescription: String? {
        switch self {
        case let .badResponse(url, status):
            "GitHub returned \(status) for \(url.lastPathComponent)."
        }
    }
}

enum ContentSyncService {
    static func loadLocalLibrary() -> ContentManifest? {
        guard let data = try? Data(contentsOf: ContentStorage.libraryURL) else { return nil }
        return try? JSONDecoder().decode(ContentManifest.self, from: data)
    }

    /// Downloads the manifest, then fetches notes and lyrics only for songs that are new
    /// or whose `version` changed. Media files are not downloaded here.
    /// Nothing is saved unless every step succeeds, so a failed refresh keeps the old library.
    static func sync(current: ContentManifest?) async throws -> (ContentManifest, SyncSummary) {
        var remote: ContentManifest = try JSONDecoder().decode(
            ContentManifest.self,
            from: try await fetchData(ContentConfig.manifestURL)
        )

        let existingByID = Dictionary(
            (current?.songs ?? []).map { ($0.id, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        var summary = SyncSummary()

        for index in remote.songs.indices {
            let song = remote.songs[index]

            if let existing = existingByID[song.id], existing.version == song.version {
                remote.songs[index].notes = song.notes ?? existing.notes
                remote.songs[index].lyrics = song.lyrics ?? existing.lyrics
                continue
            }

            if song.notes == nil, let url = song.notesUrl {
                remote.songs[index].notes = try await fetchText(url)
            }
            if song.lyrics == nil, let url = song.lyricsUrl {
                remote.songs[index].lyrics = try await fetchText(url)
            }

            if existingByID[song.id] == nil {
                summary.added += 1
            } else {
                summary.updated += 1
            }
        }

        let remoteIDs = Set(remote.songs.map(\.id))
        summary.removed = existingByID.keys.filter { !remoteIDs.contains($0) }.count

        let data = try JSONEncoder().encode(remote)
        try data.write(to: ContentStorage.libraryURL, options: .atomic)
        removeUnreferencedMedia(keeping: remote.referencedMediaPaths)

        return (remote, summary)
    }

    /// Deletes media for songs that were removed, or whose file URL changed.
    private static func removeUnreferencedMedia(keeping referenced: Set<String>) {
        let mediaURL = ContentStorage.mediaURL
        guard let enumerator = FileManager.default.enumerator(at: mediaURL, includingPropertiesForKeys: [.isRegularFileKey]) else {
            return
        }
        let prefix = mediaURL.standardizedFileURL.path + "/"
        for case let fileURL as URL in enumerator {
            guard (try? fileURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true else { continue }
            let relative = fileURL.standardizedFileURL.path.replacingOccurrences(of: prefix, with: "")
            if !referenced.contains(relative) {
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
    }

    private static func fetchData(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard status == 200 else { throw ContentSyncError.badResponse(url, status) }
        return data
    }

    private static func fetchText(_ url: URL) async throws -> String {
        String(decoding: try await fetchData(url), as: UTF8.self)
    }
}

/// Downloads audio and video once and tracks which files are on the device.
@MainActor
final class MediaDownloadStore: ObservableObject {
    @Published private(set) var progress: [String: Double] = [:]
    @Published private(set) var failures: [String: String] = [:]
    @Published private(set) var downloadedPaths: Set<String> = []

    init() {
        refreshDownloadedPaths()
    }

    func localURL(for resource: SongResource) -> URL? {
        guard let path = resource.localPath, downloadedPaths.contains(path) else { return nil }
        return ContentStorage.mediaFileURL(relativePath: path)
    }

    func isDownloading(_ resource: SongResource) -> Bool {
        progress[resource.id] != nil
    }

    func download(_ resource: SongResource) async {
        guard let remoteURL = resource.remoteURL,
              let path = resource.localPath,
              !downloadedPaths.contains(path),
              progress[resource.id] == nil else {
            return
        }

        progress[resource.id] = 0
        failures[resource.id] = nil
        let resourceID = resource.id

        do {
            let delegate = DownloadProgressDelegate { [weak self] fraction in
                Task { @MainActor in
                    if self?.progress[resourceID] != nil {
                        self?.progress[resourceID] = fraction
                    }
                }
            }
            let (tempURL, response) = try await URLSession.shared.download(from: remoteURL, delegate: delegate)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard status == 200 else {
                try? FileManager.default.removeItem(at: tempURL)
                throw ContentSyncError.badResponse(remoteURL, status)
            }

            let destination = ContentStorage.mediaFileURL(relativePath: path)
            try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: tempURL, to: destination)
            downloadedPaths.insert(path)
        } catch {
            failures[resourceID] = error.localizedDescription
        }

        progress[resourceID] = nil
    }

    func downloadAll(_ songs: [Song]) async {
        for resource in songs.flatMap(\.resources) where resource.remoteURL != nil {
            await download(resource)
        }
    }

    func pendingCount(in songs: [Song]) -> Int {
        songs.flatMap(\.resources).filter { resource in
            guard resource.remoteURL != nil, let path = resource.localPath else { return false }
            return !downloadedPaths.contains(path)
        }.count
    }

    func deleteAll() {
        try? FileManager.default.removeItem(at: ContentStorage.mediaURL)
        failures = [:]
        refreshDownloadedPaths()
    }

    var storageUsedBytes: Int64 {
        downloadedPaths.reduce(into: Int64(0)) { total, path in
            let url = ContentStorage.mediaFileURL(relativePath: path)
            total += Int64((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
        }
    }

    /// Re-scans the media folder, e.g. after a sync removed stale files.
    func refreshDownloadedPaths() {
        let mediaURL = ContentStorage.mediaURL
        let prefix = mediaURL.standardizedFileURL.path + "/"
        var paths: Set<String> = []
        if let enumerator = FileManager.default.enumerator(at: mediaURL, includingPropertiesForKeys: [.isRegularFileKey]) {
            for case let fileURL as URL in enumerator
            where (try? fileURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true {
                paths.insert(fileURL.standardizedFileURL.path.replacingOccurrences(of: prefix, with: ""))
            }
        }
        downloadedPaths = paths
    }
}

private final class DownloadProgressDelegate: NSObject, URLSessionTaskDelegate {
    private let onProgress: (Double) -> Void
    private var observation: NSKeyValueObservation?

    init(onProgress: @escaping (Double) -> Void) {
        self.onProgress = onProgress
    }

    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        observation = task.progress.observe(\.fractionCompleted) { [onProgress] progress, _ in
            onProgress(progress.fractionCompleted)
        }
    }
}
