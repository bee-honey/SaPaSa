import SwiftUI

struct FilterSheet: View {
    @EnvironmentObject private var library: SongLibraryStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Raagam") {
                    Picker("Raagam", selection: $library.selectedRaagam) {
                        Text("All").tag(String?.none)
                        ForEach(library.raagamOptions, id: \.self) { raagam in
                            Text(raagam).tag(String?.some(raagam))
                        }
                    }
                }

                Section("Thalam") {
                    Picker("Thalam", selection: $library.selectedThalam) {
                        Text("All").tag(String?.none)
                        ForEach(library.thalamOptions, id: \.self) { thalam in
                            Text(thalam).tag(String?.some(thalam))
                        }
                    }
                }

                Section("Availability") {
                    Toggle("Has audio", isOn: $library.showOnlyWithAudio)
                    Toggle("Has video", isOn: $library.showOnlyWithVideo)
                }

                Section {
                    Button("Clear filters") {
                        library.clearFilters()
                    }
                    .foregroundStyle(AppTheme.primary)
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
