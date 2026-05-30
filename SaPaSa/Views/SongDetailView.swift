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
                VideoPlaceholder(song: song)
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

private struct VideoPlaceholder: View {
    let song: Song

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "play.rectangle.fill")
                .font(.system(size: 54))
                .foregroundStyle(AppTheme.primary)

            Text("Video practice")
                .font(.headline)

            Text("Video is available for \(song.title). The bottom audio player is hidden in this tab.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppTheme.mutedInk)
        }
        .frame(maxWidth: .infinity)
        .sapasaCard()
    }
}

private struct MiniAudioPlayer: View {
    let song: Song
    @State private var isPlaying = false
    @State private var progress = 0.28

    var durationText: String {
        guard let seconds = song.resources.first(where: { $0.type == .audio })?.durationSeconds else {
            return "0:00"
        }
        return "\(seconds / 60):\(String(format: "%02d", seconds % 60))"
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .frame(width: 42, height: 42)
                    .foregroundStyle(.white)
                    .background(AppTheme.primary)
                    .clipShape(Circle())
            }
            .accessibilityLabel(isPlaying ? "Pause audio" : "Play audio")

            VStack(alignment: .leading, spacing: 5) {
                Text("Practice audio")
                    .font(.subheadline.weight(.semibold))
                ProgressView(value: progress)
                    .tint(AppTheme.gold)
                HStack {
                    Text("1:08")
                    Spacer()
                    Text(durationText)
                }
                .font(.caption2)
                .foregroundStyle(AppTheme.mutedInk)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: AppTheme.ink.opacity(0.14), radius: 14, x: 0, y: 6)
    }
}
