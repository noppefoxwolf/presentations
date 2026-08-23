//
//  FlexibilityExamples.swift
//  Example
//

import SwiftUI

struct RigidCardExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("A fixed frame leaves unused space and clips longer content.")
                .foregroundStyle(.secondary)
            NewsCard(title: "A longer headline that cannot fit in the fixed card", fixedSize: true)
            Spacer()
        }
        .padding()
    }
}

struct ContainerFillExampleView: View {
    var body: some View {
        LinearGradient(
            colors: [.indigo, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .overlay {
                Text("Color fills any container")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .padding()
    }
}

struct ScalingExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 360, maxHeight: 240)
                .foregroundStyle(.tint)
                .accessibilityLabel("Artwork")
            Text("The artwork preserves its aspect ratio while the container changes.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ScrollingExampleView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(1...12, id: \.self) { index in
                    Label("Article \(index)", systemImage: "doc.text")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
    }
}

struct ContentSizeExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Content determines the card height")
                .font(.headline)
            NewsCard(
                title: "Text grows to accommodate localization, Dynamic Type, and user-generated content.",
                fixedSize: false
            )
            Spacer()
        }
        .padding()
    }
}

struct OmissionExampleView: View {
    @State var level = 0
    var body: some View {
        VStack(spacing: 100) {
            MusicCard(showDetailsLevel: level)
                .animation(.default, value: level)
            Stepper(value: $level) {
                Text("Level")
            }.fixedSize()
        }
    }
}

struct OmissionExampleView2: View {
    var body: some View {
        HStack(spacing: 100) {
            MusicCard(showDetailsLevel: 0)
            MusicCard(showDetailsLevel: 1)
            MusicCard(showDetailsLevel: 2)
        }
    }
}

struct CollapsingExampleView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                isExpanded.toggle()
            } label: {
                Label("Followers", systemImage: "person.2")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.bordered)

            if isExpanded {
                FollowerListView()
            } else {
                Text("Show the list only when it is needed.")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}

struct TextAdaptationExampleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("One line when there is room")
                .lineLimit(1)
                .exampleTextCard()
            Text("This title wraps when the container becomes narrower.")
                .exampleTextCard()
            
            Text("小型警察犬、迷子の20代男性を発見し表彰")
                .exampleTextCard()
            
            Text("小型警察犬、迷子の20代男性を発見し表彰")
                .exampleTextCard()
                .frame(width: 200)
            
            Text("小型警察犬、迷子の20代男性を発見し表彰")
                .exampleTextCard()
                .frame(width: 100, height: 36)
            
            Spacer()
        }
        .padding()
    }
}

struct ViewThatFitsExampleView: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            Label("Play Midnight City", systemImage: "play.fill")
                .labelStyle(.titleAndIcon)
                .frame(minWidth: 220)
            Label("Play", systemImage: "play.fill")
                .labelStyle(.titleOnly)
                .frame(minWidth: 72)
            Label("Play", systemImage: "play.fill")
                .labelStyle(.iconOnly)
                .frame(minWidth: 32)
        }
        .font(.title2)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ResponsiveLayoutExampleView: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 20) {
                LibrarySidebarView()
                    .frame(width: 180)
                LibraryDetailView()
            }
            VStack(alignment: .leading, spacing: 20) {
                LibrarySidebarView()
                LibraryDetailView()
            }
        }
        .padding()
    }
}

private struct NewsCard: View {
    let title: LocalizedStringKey
    let fixedSize: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .lineLimit(fixedSize ? 2 : nil)
            Text("news.example.com")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("12 minutes ago")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: fixedSize ? 250 : nil, height: fixedSize ? 130 : nil, alignment: .topLeading)
        .frame(maxWidth: fixedSize ? nil : .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct MusicCard: View {
    let showDetailsLevel: Int

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note")
                .font(.largeTitle)
                .frame(width: 128, height: 128)
                .background(.tint, in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
            
            if showDetailsLevel > 0 {
                VStack(alignment: .leading) {
                    if showDetailsLevel > 0 {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Midnight City").font(.headline)
                                
                                if showDetailsLevel < 2 {
                                    Image(systemName: "ellipsis.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Text("M83").foregroundStyle(.secondary)
                        }
                    }
                    if showDetailsLevel > 1 {
                        HStack {
                            Button {
                                
                            } label: {
                                Label("100", systemImage: "message")
                            }
                            Button {
                                
                            } label: {
                                Label("100", systemImage: "heart")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct FollowerListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(["Aya", "Mika", "Ren"], id: \.self) { name in
                Label(name, systemImage: "person.crop.circle")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct LibrarySidebarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Library", systemImage: "books.vertical")
            Label("Favorites", systemImage: "star")
            Label("Downloads", systemImage: "arrow.down.circle")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct LibraryDetailView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Now Playing").font(.headline)
            Text("An adaptive layout changes its structure at an appropriate boundary.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}

private extension View {
    func exampleTextCard() -> some View {
        padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Fixed-size UI") { RigidCardExampleView() }
#Preview("Fill the container") { ContainerFillExampleView() }
#Preview("Scale content") { ScalingExampleView() }
#Preview("Scrollable content") { ScrollingExampleView() }
#Preview("Content-driven size") { ContentSizeExampleView() }
#Preview("Omit and expand") { OmissionExampleView() }
#Preview("Omit and expand 2") { OmissionExampleView2() }
#Preview("Collapse and expand") { CollapsingExampleView() }
#Preview("Text adaptation") { TextAdaptationExampleView() }
#Preview("ViewThatFits") { ViewThatFitsExampleView() }
#Preview("Responsive layout") { ResponsiveLayoutExampleView() }
