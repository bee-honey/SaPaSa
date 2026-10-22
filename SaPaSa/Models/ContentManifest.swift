import CryptoKit
import Foundation

/// The shape of `manifest.json` in the GitHub content repo.
/// The same structure is saved on device as the local library, with
/// `notes` and `lyrics` filled in from their URLs so it works offline.
struct ContentManifest: Codable {
    var schemaVersion: Int
    var raagams: [RaagamEntry]
    var thalams: [ThalamEntry]
    var songs: [SongEntry]
}

struct RaagamEntry: Codable {
    let id: String
    let name: String
    let hindustaniName: String?
    let isMelakartha: Bool?
    let arohanam: String
    let avarohanam: String
}

struct ThalamEntry: Codable {
    let id: String
    let name: String
    let beats: Int
    let structure: String
}

struct ArtistEntry: Codable {
    let name: String
    let role: String
}

struct SongEntry: Codable {
    let id: String
    /// Bump this whenever the song's notes, lyrics, or details change.
    let version: Int
    let title: String
    let subtitle: String?
    let raagam: String
    let thalam: String
    let artists: [ArtistEntry]?
    var notes: String?
    let notesUrl: URL?
    var lyrics: String?
    let lyricsUrl: URL?
    let media: [MediaEntry]?
}

struct MediaEntry: Codable {
    let id: String
    let type: String
    let title: String?
    let url: URL
    let durationSeconds: Int?
    let sizeBytes: Int?

    /// Relative path inside the media folder. It includes a hash of the URL,
    /// so pointing a media entry at a new file triggers a fresh download.
    func localPath(songID: String) -> String {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        let hash = digest.prefix(6).map { String(format: "%02x", $0) }.joined()
        let ext = url.pathExtension.isEmpty ? (type == "video" ? "mp4" : "mp3") : url.pathExtension
        return "\(songID)/\(id)-\(hash).\(ext)"
    }
}

extension ContentManifest {
    func makeSongs() -> [Song] {
        let raagamsByID = Dictionary(raagams.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let thalamsByID = Dictionary(thalams.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

        return songs.map { entry in
            let raagam = raagamsByID[entry.raagam].map {
                Raagam(
                    id: $0.id,
                    name: $0.name,
                    hindustaniName: $0.hindustaniName,
                    isMelakartha: $0.isMelakartha ?? false,
                    arohanam: $0.arohanam,
                    avarohanam: $0.avarohanam
                )
            } ?? Raagam(id: entry.raagam, name: entry.raagam.capitalized, hindustaniName: nil, isMelakartha: false, arohanam: "", avarohanam: "")

            let thalam = thalamsByID[entry.thalam].map {
                Thalam(id: $0.id, name: $0.name, beats: $0.beats, structure: $0.structure)
            } ?? Thalam(id: entry.thalam, name: entry.thalam.capitalized, beats: 0, structure: "")

            let artists = (entry.artists ?? []).enumerated().map { index, artist in
                SongArtist(
                    id: "\(entry.id)-artist-\(index)",
                    name: artist.name,
                    role: ArtistRole(rawValue: artist.role.lowercased()) ?? .performer
                )
            }

            let media = (entry.media ?? []).compactMap { item -> SongResource? in
                guard let type = SongResourceType(rawValue: item.type.lowercased()),
                      type == .audio || type == .video else {
                    return nil
                }
                return SongResource(
                    id: "\(entry.id)-\(item.id)",
                    type: type,
                    title: item.title ?? type.title,
                    localPath: item.localPath(songID: entry.id),
                    remoteURL: item.url,
                    format: item.url.pathExtension,
                    durationSeconds: item.durationSeconds,
                    isBundled: false,
                    sizeBytes: item.sizeBytes
                )
            }

            return Song(
                id: entry.id,
                title: entry.title,
                subtitle: entry.subtitle ?? "",
                raagam: raagam,
                thalam: thalam,
                artists: artists,
                notes: entry.notes ?? "",
                lyrics: entry.lyrics ?? "",
                resources: media,
                source: "GitHub",
                remoteVersion: entry.version
            )
        }
    }

    /// Every media file the library currently references, relative to the media folder.
    var referencedMediaPaths: Set<String> {
        Set(songs.flatMap { song in
            (song.media ?? []).map { $0.localPath(songID: song.id) }
        })
    }
}
