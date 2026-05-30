import SwiftUI

@main
struct SaPaSaApp: App {
    @StateObject private var library = SongLibraryStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(library)
        }
    }
}
