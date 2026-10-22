import Foundation

@MainActor
final class SongLibraryStore: ObservableObject {
    @Published private(set) var songs: [Song]
    @Published var favoriteSongIDs: Set<String>
    @Published var selectedRaagam: String?
    @Published var selectedThalam: String?
    @Published var showOnlyWithAudio = false
    @Published var showOnlyWithVideo = false
    @Published var lastRefreshMessage = "Bundled library loaded"
    @Published private(set) var isRefreshing = false
    @Published private(set) var lastRefreshDate: Date?

    private let favoritesKey = "sapasa.favoriteSongIDs"
    private let lastRefreshKey = "sapasa.lastRefreshDate"
    private var localLibrary: ContentManifest?

    init() {
        localLibrary = ContentSyncService.loadLocalLibrary()
        songs = localLibrary?.makeSongs() ?? SampleLibrary.songs
        favoriteSongIDs = Set(UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [])
        lastRefreshDate = UserDefaults.standard.object(forKey: lastRefreshKey) as? Date
        if localLibrary != nil {
            lastRefreshMessage = "Library saved on this device."
        }
    }

    /// Syncs once, on first launch. After that the saved library is used until the user taps Refresh.
    func syncIfNeeded() async {
        guard localLibrary == nil else { return }
        await refreshLibrary()
    }

    var favoriteSongs: [Song] {
        songs.filter { favoriteSongIDs.contains($0.id) }
    }

    var raagamOptions: [String] {
        Array(Set(songs.map { $0.raagam.name })).sorted()
    }

    var thalamOptions: [String] {
        Array(Set(songs.map { $0.thalam.name })).sorted()
    }

    func filteredSongs(searchText: String, favoritesOnly: Bool = false) -> [Song] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return songs.filter { song in
            if favoritesOnly && !favoriteSongIDs.contains(song.id) {
                return false
            }

            if let selectedRaagam, song.raagam.name != selectedRaagam {
                return false
            }

            if let selectedThalam, song.thalam.name != selectedThalam {
                return false
            }

            if showOnlyWithAudio && !song.hasAudio {
                return false
            }

            if showOnlyWithVideo && !song.hasVideo {
                return false
            }

            if query.isEmpty {
                return true
            }

            return song.title.lowercased().contains(query)
                || song.subtitle.lowercased().contains(query)
                || song.raagam.name.lowercased().contains(query)
                || song.thalam.name.lowercased().contains(query)
                || song.artists.contains { $0.name.lowercased().contains(query) }
        }
    }

    func toggleFavorite(_ song: Song) {
        if favoriteSongIDs.contains(song.id) {
            favoriteSongIDs.remove(song.id)
        } else {
            favoriteSongIDs.insert(song.id)
        }
        UserDefaults.standard.set(Array(favoriteSongIDs), forKey: favoritesKey)
    }

    func isFavorite(_ song: Song) -> Bool {
        favoriteSongIDs.contains(song.id)
    }

    func clearFilters() {
        selectedRaagam = nil
        selectedThalam = nil
        showOnlyWithAudio = false
        showOnlyWithVideo = false
    }

    func refreshLibrary() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let (library, summary) = try await ContentSyncService.sync(current: localLibrary)
            localLibrary = library
            songs = library.makeSongs()
            lastRefreshDate = Date()
            UserDefaults.standard.set(lastRefreshDate, forKey: lastRefreshKey)
            lastRefreshMessage = summary.message
        } catch {
            lastRefreshMessage = "Could not refresh: \(error.localizedDescription)"
        }
    }
}

enum SampleLibrary {
    static let adi = Thalam(id: "adi", name: "Adi", beats: 8, structure: "4 + 2 + 2")
    static let rupakam = Thalam(id: "rupakam", name: "Rupakam", beats: 6, structure: "3 + 3")

    static let hamsadhwani = Raagam(
        id: "hamsadhwani",
        name: "Hamsadhwani",
        hindustaniName: nil,
        isMelakartha: false,
        arohanam: "sa ri2 ga3 pa ni3 sa",
        avarohanam: "sa ni3 pa ga3 ri2 sa"
    )

    static let mayamalavagowla = Raagam(
        id: "mayamalavagowla",
        name: "Mayamalavagowla",
        hindustaniName: "Bhairav",
        isMelakartha: true,
        arohanam: "sa ri1 ga3 ma1 pa da1 ni3 sa",
        avarohanam: "sa ni3 da1 pa ma1 ga3 ri1 sa"
    )

    static let mohanam = Raagam(
        id: "mohanam",
        name: "Mohanam",
        hindustaniName: "Bhoop",
        isMelakartha: false,
        arohanam: "sa ri2 ga3 pa da2 sa",
        avarohanam: "sa da2 pa ga3 ri2 sa"
    )

    static let songs: [Song] = [
        Song(
            id: "vatapi-ganapathim",
            title: "Vatapi Ganapathim",
            subtitle: "A bright opening kriti for practice",
            raagam: hamsadhwani,
            thalam: adi,
            artists: [
                SongArtist(id: "muthuswami-dikshitar-composer", name: "Muthuswami Dikshitar", role: .composer),
                SongArtist(id: "sample-vocalist", name: "SaPaSa Practice Vocal", role: .singer)
            ],
            notes: """
            Pallavi
            sa ri ga pa | ni sa ni pa |
            ga ri sa - | vatapi ganapathim bhajeham

            Anupallavi
            bhutadi samsevita charanam
            bhuta bhautika prapancha bharanam
            """,
            lyrics: """
            Pallavi
            Vatapi ganapathim bhajeham
            Varanasyam vara pradham shri

            Anupallavi
            Bhutadi samsevita charanam
            Bhuta bhautika prapancha bharanam
            """,
            resources: [
                SongResource(id: "vatapi-notes", type: .notes, title: "Practice notes", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true),
                SongResource(id: "vatapi-lyrics", type: .lyrics, title: "Lyrics", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true),
                SongResource(id: "vatapi-audio", type: .audio, title: "Practice audio", localPath: nil, remoteURL: nil, format: "mp3", durationSeconds: 248, isBundled: false),
                SongResource(id: "vatapi-video", type: .video, title: "Reference video", localPath: nil, remoteURL: nil, format: "mp4", durationSeconds: 420, isBundled: false)
            ],
            source: "Bundled",
            remoteVersion: 1
        ),
        Song(
            id: "lambodara",
            title: "Lambodara Lakumikara",
            subtitle: "Beginner geetham",
            raagam: mayamalavagowla,
            thalam: rupakam,
            artists: [
                SongArtist(id: "purandara-dasa-creator", name: "Purandara Dasa", role: .creator),
                SongArtist(id: "practice-teacher", name: "SaPaSa Lesson Voice", role: .singer)
            ],
            notes: """
            sa ri ga ma | pa da ni sa
            sa ni da pa | ma ga ri sa

            Lambodara lakumikara
            Ambasutana amaravinuta
            """,
            lyrics: """
            Lambodara lakumikara
            Ambasutana amaravinuta
            Shri gananatha sindhura varna
            """,
            resources: [
                SongResource(id: "lambodara-notes", type: .notes, title: "Practice notes", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true),
                SongResource(id: "lambodara-lyrics", type: .lyrics, title: "Lyrics", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true),
                SongResource(id: "lambodara-audio", type: .audio, title: "Slow practice audio", localPath: nil, remoteURL: nil, format: "mp3", durationSeconds: 180, isBundled: false)
            ],
            source: "Bundled",
            remoteVersion: 1
        ),
        Song(
            id: "ninnukori",
            title: "Ninnukori Varnam",
            subtitle: "Varnam for swara practice",
            raagam: mohanam,
            thalam: adi,
            artists: [
                SongArtist(id: "ramnad-srinivasa-iyengar-composer", name: "Ramnad Srinivasa Iyengar", role: .composer)
            ],
            notes: """
            sa ri ga pa | da sa - -
            sa da pa ga | ri sa - -

            Ninnukori yunnara
            Nikila loka nayaka
            """,
            lyrics: """
            Ninnukori yunnara
            Nikila loka nayaka
            Nannu brova rada
            """,
            resources: [
                SongResource(id: "ninnukori-notes", type: .notes, title: "Varnam notes", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true),
                SongResource(id: "ninnukori-lyrics", type: .lyrics, title: "Lyrics", localPath: "Bundled", remoteURL: nil, format: "text", durationSeconds: nil, isBundled: true)
            ],
            source: "Bundled",
            remoteVersion: 1
        )
    ]
}
