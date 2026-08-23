//
//  NavigationSplitViewExampleView.swift
//  Example
//

import SwiftUI

struct NavigationSplitViewExampleView: View {
    @State private var selectedSection: LibrarySection? = .recent
    @State private var selectedTrack: LibraryTrack? = .midnightCity
    @State private var isInspectorPresented = true

    var body: some View {
        NavigationSplitView {
            LibrarySidebarView(selection: $selectedSection)
        } content: {
            LibraryTrackListView(
                section: selectedSection,
                selection: $selectedTrack
            )
        } detail: {
            LibraryTrackDetailView(
                track: selectedTrack,
                isInspectorPresented: $isInspectorPresented
            )
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: selectedSection) { _, newSection in
            selectedTrack = newSection?.tracks.first
        }
        .inspector(isPresented: $isInspectorPresented) {
            LibraryTrackInspectorView(track: selectedTrack)
        }
    }
}

private struct LibrarySidebarView: View {
    @Binding var selection: LibrarySection?

    var body: some View {
        List(selection: $selection) {
            Section("Library") {
                ForEach(LibrarySection.allCases) { section in
                    Label(section.title, systemImage: section.symbolName)
                        .tag(section)
                }
            }
        }
        .navigationTitle("Music")
    }
}

private struct LibraryTrackListView: View {
    let section: LibrarySection?
    @Binding var selection: LibraryTrack?

    var body: some View {
        List(selection: $selection) {
            if let section {
                ForEach(section.tracks) { track in
                    LibraryTrackRow(track: track)
                        .tag(track)
                }
            } else {
                ContentUnavailableView(
                    "Select a section",
                    systemImage: "sidebar.left"
                )
            }
        }
        .navigationTitle(section?.title ?? "Tracks")
    }
}

private struct LibraryTrackRow: View {
    let track: LibraryTrack

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: track.symbolName)
                .frame(width: 36, height: 36)
                .background(.tint, in: RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                Text(track.artist)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct LibraryTrackDetailView: View {
    let track: LibraryTrack?
    @Binding var isInspectorPresented: Bool

    var body: some View {
        if let track {
            VStack(spacing: 20) {
                Image(systemName: track.symbolName)
                    .font(.system(size: 72))
                    .frame(width: 180, height: 180)
                    .background(
                        LinearGradient(
                            colors: [.indigo, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 24)
                    )
                    .foregroundStyle(.white)
                VStack(spacing: 6) {
                    Text(track.title)
                        .font(.title.weight(.bold))
                    Text(track.artist)
                        .foregroundStyle(.secondary)
                    Text(track.album)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(track.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isInspectorPresented.toggle()
                    } label: {
                        Label("Inspector", systemImage: "slider.horizontal.3")
                    }
                }
            }
        } else {
            ContentUnavailableView(
                "Select a track",
                systemImage: "music.note.list"
            )
        }
    }
}

private struct LibraryTrackInspectorView: View {
    let track: LibraryTrack?

    var body: some View {
        Form {
            Section("Track") {
                InspectorValueRow(label: "Title", value: track?.title ?? "No Selection")
                InspectorValueRow(label: "Artist", value: track?.artist ?? "")
                InspectorValueRow(label: "Album", value: track?.album ?? "")
            }

            Section("Playback") {
                LabeledContent("Quality", value: "Lossless")
                Toggle("Downloaded", isOn: .constant(track == .intro))
                    .disabled(true)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Inspector")
    }
}

private struct InspectorValueRow: View {
    let label: LocalizedStringKey
    let value: LocalizedStringKey

    var body: some View {
        LabeledContent(label) {
            Text(value)
        }
    }
}

private enum LibrarySection: CaseIterable, Identifiable, Hashable {
    case recent
    case favorites
    case downloaded

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .recent: "Recently Played"
        case .favorites: "Favorites"
        case .downloaded: "Downloaded"
        }
    }

    var symbolName: String {
        switch self {
        case .recent: "clock"
        case .favorites: "star"
        case .downloaded: "arrow.down.circle"
        }
    }

    var tracks: [LibraryTrack] {
        switch self {
        case .recent: [.midnightCity, .intro, .sunset]
        case .favorites: [.midnightCity, .sunset]
        case .downloaded: [.intro, .midnightCity]
        }
    }
}

private enum LibraryTrack: CaseIterable, Identifiable, Hashable {
    case midnightCity
    case intro
    case sunset

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .midnightCity: "Midnight City"
        case .intro: "Intro"
        case .sunset: "Sunset Lover"
        }
    }

    var artist: LocalizedStringKey {
        switch self {
        case .midnightCity: "M83"
        case .intro: "The xx"
        case .sunset: "Petit Biscuit"
        }
    }

    var album: LocalizedStringKey {
        switch self {
        case .midnightCity: "Hurry Up, We're Dreaming"
        case .intro: "xx"
        case .sunset: "Presence"
        }
    }

    var symbolName: String {
        switch self {
        case .midnightCity: "music.note"
        case .intro: "headphones"
        case .sunset: "sun.max"
        }
    }
}

#Preview {
    NavigationSplitViewExampleView()
}
