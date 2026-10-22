import AVKit
import SwiftUI

struct SongDetailView: View {
    @EnvironmentObject private var library: SongLibraryStore
    let song: Song
    @State private var selectedTab: PracticeTab = .notes
    @State private var showingInfo = false

    private var availableTabs: [PracticeTab] {
        song.hasVideo ? [.notes, .lyrics, .video] : [.notes, .lyrics]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SongDetailHeader(song: song)

                    DisclosureGroup(isExpanded: $showingInfo) {
                        SongInfoPanel(song: song)
                            .padding(.top, 10)
                    } label: {
                        Label("Song information", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.primary)
                    }
                    .sapasaCard()

                    Picker("Practice", selection: $selectedTab) {
                        ForEach(availableTabs) { tab in
                            Text(tab.title).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)

                    PracticeContent(song: song, selectedTab: selectedTab)
                        .padding(.bottom, song.hasAudio && selectedTab != .video ? 96 : 16)
                }
                .padding(18)
            }

            if song.hasAudio && selectedTab != .video {
                MiniAudioPlayer(song: song)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 10)
            }
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                library.toggleFavorite(song)
            } label: {
                Image(systemName: library.isFavorite(song) ? "heart.fill" : "heart")
            }
            .tint(AppTheme.primary)
        }
    }
}

private struct SongDetailHeader: View {
    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(song.title)
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            Text(song.subtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.mutedInk)

            HStack {
                Label(song.raagam.name, systemImage: "waveform")
                Label(song.thalam.name, systemImage: "metronome")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppTheme.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sapasaCard()
    }
}

private struct SongInfoPanel: View {
    let song: Song

    var groupedArtists: [(ArtistRole, [SongArtist])] {
        ArtistRole.allCases.compactMap { role in
            let artists = song.artists.filter { $0.role == role }
            return artists.isEmpty ? nil : (role, artists)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(groupedArtists, id: \.0) { role, artists in
                InfoLine(title: role.title, value: artists.map(\.name).joined(separator: ", "))
            }

            Divider()

            InfoLine(title: "Thalam", value: "\(song.thalam.name), \(song.thalam.beats) beats, \(song.thalam.structure)")
            InfoLine(title: "Raagam", value: song.raagam.name)
            InfoLine(title: "Arohanam", value: song.raagam.arohanam)
            InfoLine(title: "Avarohanam", value: song.raagam.avarohanam)
            InfoLine(title: "Melakartha", value: song.raagam.isMelakartha ? "Yes" : "No")

            if let hindustaniName = song.raagam.hindustaniName {
                InfoLine(title: "Hindustani", value: hindustaniName)
            }
        }
    }
}

private struct InfoLine: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct PracticeContent: View {
    let song: Song
    let selectedTab: PracticeTab

    var body: some View {
        Group {
            switch selectedTab {
            case .notes:
                TextPracticePanel(title: "Notes", content: song.notes, systemImage: "music.note")
            case .lyrics:
                TextPracticePanel(title: "Lyrics", content: song.lyrics, systemImage: "text.quote")
            case .video:
                VideoPanel(song: song)
            }
        }
    }
}

private struct TextPracticePanel: View {
    let title: String
    let content: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(AppTheme.primary)

            Text(content)
                .font(.system(.body, design: .serif))
                .lineSpacing(8)
                .foregroundStyle(AppTheme.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sapasaCard()
    }
}

private struct VideoPanel: View {
    @EnvironmentObject private var downloads: MediaDownloadStore
    let song: Song
    @State private var player: AVPlayer?

    private var video: SongResource? {
        song.resources.first { $0.type == .video }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(video?.title ?? "Video", systemImage: "play.rectangle.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.primary)

            if let video, let url = downloads.localURL(for: video) {
                VideoPlayer(player: player)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .onAppear {
                        if player == nil { player = AVPlayer(url: url) }
                    }
                    .onDisappear { player?.pause() }
            } else if let video {
                MediaDownloadButton(resource: video)
            } else {
                Text("Video is not available yet.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.mutedInk)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sapasaCard()
    }
}

/// Shows a Download button, progress while downloading, or the error from the last attempt.
struct MediaDownloadButton: View {
    @EnvironmentObject private var downloads: MediaDownloadStore
    let resource: SongResource

    private var sizeText: String {
        guard let bytes = resource.sizeBytes else { return "" }
        return " (" + ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file) + ")"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if resource.remoteURL == nil {
                Text("Not available for download yet.")
                    .font(.caption)
                    .foregroundStyle(AppTheme.mutedInk)
            } else if let fraction = downloads.progress[resource.id] {
                ProgressView(value: fraction) {
                    Text("Downloading \(Int(fraction * 100))%")
                        .font(.caption)
                        .foregroundStyle(AppTheme.mutedInk)
                }
                .tint(AppTheme.gold)
            } else {
                Button {
                    Task { await downloads.download(resource) }
                } label: {
                    Label("Download\(sizeText)", systemImage: "arrow.down.circle.fill")
                        .font(.subheadline.weight(.semibold))
                }
                .tint(AppTheme.primary)

                if let failure = downloads.failures[resource.id] {
                    Text(failure)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

@MainActor
private final class AudioPlayerModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var endObserver: NSObjectProtocol?
    private var loadedURL: URL?

    func load(_ url: URL, fallbackDuration: Int?) {
        guard loadedURL != url else { return }
        stop()
        loadedURL = url
        duration = Double(fallbackDuration ?? 0)

        let player = AVPlayer(url: url)
        self.player = player
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            MainActor.assumeIsolated {
                guard let self else { return }
                self.currentTime = time.seconds
                if let seconds = player.currentItem?.duration.seconds, seconds.isFinite {
                    self.duration = seconds
                }
            }
        }
        endObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.isPlaying = false
                self?.seek(to: 0)
            }
        }
    }

    func togglePlayback() {
        guard let player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    func seek(to seconds: Double) {
        currentTime = seconds
        player?.seek(to: CMTime(seconds: seconds, preferredTimescale: 600))
    }

    func stop() {
        player?.pause()
        if let timeObserver { player?.removeTimeObserver(timeObserver) }
        if let endObserver { NotificationCenter.default.removeObserver(endObserver) }
        timeObserver = nil
        endObserver = nil
        player = nil
        loadedURL = nil
        isPlaying = false
        currentTime = 0
    }
}

private struct MiniAudioPlayer: View {
    @EnvironmentObject private var downloads: MediaDownloadStore
    let song: Song
    @StateObject private var audio = AudioPlayerModel()

    private var resource: SongResource? {
        song.resources.first { $0.type == .audio }
    }

    private func timeText(_ seconds: Double) -> String {
        let total = Int(seconds.isFinite ? seconds : 0)
        return "\(total / 60):\(String(format: "%02d", total % 60))"
    }

    var body: some View {
        HStack(spacing: 12) {
            if let resource, let url = downloads.localURL(for: resource) {
                Button {
                    audio.togglePlayback()
                } label: {
                    Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
                        .frame(width: 42, height: 42)
                        .foregroundStyle(.white)
                        .background(AppTheme.primary)
                        .clipShape(Circle())
                }
                .accessibilityLabel(audio.isPlaying ? "Pause audio" : "Play audio")

                VStack(alignment: .leading, spacing: 2) {
                    Text(resource.title)
                        .font(.subheadline.weight(.semibold))
                    Slider(
                        value: Binding(get: { audio.currentTime }, set: { audio.seek(to: $0) }),
                        in: 0...max(audio.duration, 1)
                    )
                    .tint(AppTheme.gold)
                    HStack {
                        Text(timeText(audio.currentTime))
                        Spacer()
                        Text(timeText(audio.duration))
                    }
                    .font(.caption2)
                    .foregroundStyle(AppTheme.mutedInk)
                }
                .onAppear { audio.load(url, fallbackDuration: resource.durationSeconds) }
            } else if let resource {
                Image(systemName: "music.note")
                    .frame(width: 42, height: 42)
                    .foregroundStyle(AppTheme.primary)
                    .background(AppTheme.primarySoft)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(resource.title)
                        .font(.subheadline.weight(.semibold))
                    MediaDownloadButton(resource: resource)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: AppTheme.ink.opacity(0.14), radius: 14, x: 0, y: 6)
        .onDisappear { audio.stop() }
    }
}
