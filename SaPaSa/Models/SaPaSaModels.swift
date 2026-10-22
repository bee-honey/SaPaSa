import Foundation

enum SongResourceType: String, CaseIterable, Identifiable {
    case notes
    case lyrics
    case audio
    case video

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notes: "Notes"
        case .lyrics: "Lyrics"
        case .audio: "Audio"
        case .video: "Video"
        }
    }
}

enum ArtistRole: String, CaseIterable, Identifiable {
    case composer
    case lyricist
    case singer
    case creator
    case performer

    var id: String { rawValue }

    var title: String {
        switch self {
        case .composer: "Composer"
        case .lyricist: "Lyricist"
        case .singer: "Singer"
        case .creator: "Creator"
        case .performer: "Performer"
        }
    }
}

struct Raagam: Identifiable, Hashable {
    let id: String
    let name: String
    let hindustaniName: String?
    let isMelakartha: Bool
    let arohanam: String
    let avarohanam: String
}

struct Thalam: Identifiable, Hashable {
    let id: String
    let name: String
    let beats: Int
    let structure: String
}

struct SongArtist: Identifiable, Hashable {
    let id: String
    let name: String
    let role: ArtistRole
}

struct SongResource: Identifiable, Hashable {
    let id: String
    let type: SongResourceType
    let title: String
    let localPath: String?
    let remoteURL: URL?
    let format: String
    let durationSeconds: Int?
    let isBundled: Bool
    var sizeBytes: Int? = nil
}

struct Song: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let raagam: Raagam
    let thalam: Thalam
    let artists: [SongArtist]
    let notes: String
    let lyrics: String
    let resources: [SongResource]
    let source: String
    let remoteVersion: Int

    var hasAudio: Bool {
        resources.contains { $0.type == .audio }
    }

    var hasVideo: Bool {
        resources.contains { $0.type == .video }
    }

    var hasNotes: Bool {
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var hasLyrics: Bool {
        !lyrics.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

enum PracticeTab: String, CaseIterable, Identifiable {
    case notes
    case lyrics
    case video

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notes: "Notes"
        case .lyrics: "Lyrics"
        case .video: "Video"
        }
    }
}
