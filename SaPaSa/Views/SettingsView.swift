import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var library: SongLibraryStore
    @State private var isRefreshing = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Library", systemImage: "tray.and.arrow.down.fill")
                                .font(.headline)
                                .foregroundStyle(AppTheme.primary)

                            Text(library.lastRefreshMessage)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.mutedInk)

                            Button {
                                Task {
                                    isRefreshing = true
                                    await library.refreshLibrary()
                                    isRefreshing = false
                                }
                            } label: {
                                HStack {
                                    Image(systemName: isRefreshing ? "arrow.clockwise" : "arrow.triangle.2.circlepath")
                                    Text(isRefreshing ? "Refreshing" : "Refresh from GitHub")
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                                .background(AppTheme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                            .disabled(isRefreshing)
                        }
                        .sapasaCard()

                        VStack(alignment: .leading, spacing: 10) {
                            Label("Storage plan", systemImage: "internaldrive.fill")
                                .font(.headline)
                                .foregroundStyle(AppTheme.primary)

                            Text("v1 uses bundled sample data. v2 will fetch a GitHub manifest, store metadata locally, and download song media only once per installation.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.mutedInk)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .sapasaCard()
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
