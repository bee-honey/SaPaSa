import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var library: SongLibraryStore
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if library.favoriteSongs.isEmpty {
                            EmptyStateView(
                                title: "No favorites yet",
                                message: "Search songs from Home and tap the heart for quick practice."
                            )
                            .padding(.top, 40)
                        } else {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField("Search favorites", text: $searchText)
                            }
                            .padding(12)
                            .background(AppTheme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                            SongList(
                                songs: library.filteredSongs(searchText: searchText, favoritesOnly: true),
                                emptyTitle: "No favorite matches",
                                emptyMessage: "Try another song name or raagam."
                            )
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
