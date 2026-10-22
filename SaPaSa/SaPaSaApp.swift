import AVFoundation
import SwiftUI

@main
struct SaPaSaApp: App {
    @StateObject private var library = SongLibraryStore()
    @StateObject private var downloads = MediaDownloadStore()

    init() {
        // Play practice audio even when the ringer switch is silent.
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(library)
                .environmentObject(downloads)
                .task {
                    await library.syncIfNeeded()
                    downloads.refreshDownloadedPaths()
                }
        }
    }
}
