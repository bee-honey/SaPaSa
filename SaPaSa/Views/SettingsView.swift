import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var library: SongLibraryStore
    @EnvironmentObject private var downloads: MediaDownloadStore
    @State private var isDownloadingAll = false
    @State private var confirmingDelete = false

    private var pendingDownloads: Int {
        downloads.pendingCount(in: library.songs)
    }

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

                            if let date = library.lastRefreshDate {
                                Text("Last checked \(date.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.mutedInk)
                            }

                            Button {
                                Task {
                                    await library.refreshLibrary()
                                    downloads.refreshDownloadedPaths()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: library.isRefreshing ? "arrow.clockwise" : "arrow.triangle.2.circlepath")
                                    Text(library.isRefreshing ? "Refreshing" : "Refresh from GitHub")
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                                .background(AppTheme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                            .disabled(library.isRefreshing)
                        }
                        .sapasaCard()

                        VStack(alignment: .leading, spacing: 10) {
                            Label("Downloads", systemImage: "internaldrive.fill")
                                .font(.headline)
                                .foregroundStyle(AppTheme.primary)

                            Text("Audio and video download once and stay on this device. \(ByteCountFormatter.string(fromByteCount: downloads.storageUsedBytes, countStyle: .file)) used.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.mutedInk)
                                .fixedSize(horizontal: false, vertical: true)

                            if pendingDownloads > 0 || isDownloadingAll {
                                Button {
                                    Task {
                                        isDownloadingAll = true
                                        await downloads.downloadAll(library.songs)
                                        isDownloadingAll = false
                                    }
                                } label: {
                                    Label(
                                        isDownloadingAll ? "Downloading… \(pendingDownloads) left" : "Download all (\(pendingDownloads) files)",
                                        systemImage: "arrow.down.circle.fill"
                                    )
                                    .font(.subheadline.weight(.semibold))
                                }
                                .tint(AppTheme.primary)
                                .disabled(isDownloadingAll)
                            }

                            if !downloads.downloadedPaths.isEmpty {
                                Button("Remove downloaded audio & video", role: .destructive) {
                                    confirmingDelete = true
                                }
                                .font(.subheadline.weight(.semibold))
                                .disabled(isDownloadingAll)
                            }
                        }
                        .sapasaCard()
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Remove all downloaded audio and video?", isPresented: $confirmingDelete, titleVisibility: .visible) {
                Button("Remove downloads", role: .destructive) {
                    downloads.deleteAll()
                }
            } message: {
                Text("Notes and lyrics stay. Media can be downloaded again later.")
            }
        }
    }
}
