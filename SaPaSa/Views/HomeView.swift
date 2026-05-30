import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var library: SongLibraryStore
    @State private var searchText = ""
    @State private var showingFilters = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        HeroHeader()
                        SearchBar(searchText: $searchText, showingFilters: $showingFilters)
                        SongList(
                            songs: library.filteredSongs(searchText: searchText),
                            emptyTitle: "No songs found",
                            emptyMessage: "Try a different song, raagam, thalam, or artist."
                        )
                    }
                    .padding(18)
                }
                .refreshable {
                    await library.refreshLibrary()
                }
            }
            .navigationTitle("SaPaSa")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFilters) {
                FilterSheet()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

private struct HeroHeader: View {
    @EnvironmentObject private var library: SongLibraryStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SaPaSa")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                    Text("Practice Carnatic songs with notes, lyrics, audio, and video in one place.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "music.quarternote.3")
                    .font(.system(size: 32, weight: .semibold))
            }

            HStack(spacing: 10) {
                LibraryPill(title: "\(library.songs.count)", subtitle: "Songs")
                LibraryPill(title: "\(library.favoriteSongs.count)", subtitle: "Favs")
                LibraryPill(title: "v1", subtitle: "Bundle")
            }
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(AppTheme.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct LibraryPill: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(.white.opacity(0.16))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct SearchBar: View {
    @Binding var searchText: String
    @Binding var showingFilters: Bool

    var body: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(AppTheme.mutedInk)
                TextField("Search songs, raagam, thalam, artist", text: $searchText)
                    .textInputAutocapitalization(.never)
            }
            .padding(12)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Button {
                showingFilters = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white)
                    .background(AppTheme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .accessibilityLabel("Filters")
        }
    }
}

struct SongList: View {
    let songs: [Song]
    let emptyTitle: String
    let emptyMessage: String

    var body: some View {
        LazyVStack(spacing: 12) {
            if songs.isEmpty {
                EmptyStateView(title: emptyTitle, message: emptyMessage)
            } else {
                ForEach(songs) { song in
                    NavigationLink {
                        SongDetailView(song: song)
                    } label: {
                        SongRow(song: song)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct SongRow: View {
    @EnvironmentObject private var library: SongLibraryStore
    let song: Song

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(song.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)

                Text("\(song.raagam.name) - \(song.thalam.name)")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.mutedInk)

                HStack(spacing: 8) {
                    ResourceBadge(title: "Notes", isAvailable: song.hasNotes)
                    ResourceBadge(title: "Lyrics", isAvailable: song.hasLyrics)
                    ResourceBadge(title: "Audio", isAvailable: song.hasAudio)
                    ResourceBadge(title: "Video", isAvailable: song.hasVideo)
                }
            }

            Spacer()

            Button {
                library.toggleFavorite(song)
            } label: {
                Image(systemName: library.isFavorite(song) ? "heart.fill" : "heart")
                    .foregroundStyle(library.isFavorite(song) ? AppTheme.primary : AppTheme.mutedInk)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(library.isFavorite(song) ? "Remove favorite" : "Add favorite")
        }
        .sapasaCard()
    }
}

private struct ResourceBadge: View {
    let title: String
    let isAvailable: Bool

    var body: some View {
        Text(title)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(isAvailable ? AppTheme.green : AppTheme.mutedInk)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(isAvailable ? AppTheme.green.opacity(0.12) : AppTheme.surfaceMuted)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
