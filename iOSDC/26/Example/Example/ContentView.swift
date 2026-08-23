//
//  ContentView.swift
//  Example
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(ExampleScreen.allCases) { screen in
                NavigationLink(value: screen) {
                    ExampleScreenRow(screen: screen)
                }
            }
            .navigationTitle("UI Flexibility")
            .navigationDestination(for: ExampleScreen.self) { screen in
                AnimatedContainerView(preset: screen.containerPreset) {
                    screen.destination
                }
                    .navigationTitle(screen.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

private struct ExampleScreenRow: View {
    let screen: ExampleScreen

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(screen.title)
                Text(screen.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: screen.symbolName)
                .foregroundStyle(.tint)
        }
    }
}

enum ExampleScreen: String, CaseIterable, Identifiable, Hashable {
    case rigidCard, containerFill, scaling, scrolling, contentSize
    case omission, collapsing, textAdaptation, viewThatFits, responsiveLayout

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .rigidCard: "Fixed-size UI"
        case .containerFill: "Fill the container"
        case .scaling: "Scale content"
        case .scrolling: "Scrollable content"
        case .contentSize: "Content-driven size"
        case .omission: "Omit and expand"
        case .collapsing: "Collapse and expand"
        case .textAdaptation: "Text adaptation"
        case .viewThatFits: "ViewThatFits"
        case .responsiveLayout: "Responsive layout"
        }
    }

    var subtitle: LocalizedStringKey {
        switch self {
        case .rigidCard: "A deliberately inflexible reference"
        case .containerFill: "A view that follows available space"
        case .scaling: "Keep artwork proportional"
        case .scrolling: "Accept content beyond the viewport"
        case .contentSize: "Let text determine the height"
        case .omission: "Keep the most important information"
        case .collapsing: "Reveal repeated information on demand"
        case .textAdaptation: "Wrap, then truncate when necessary"
        case .viewThatFits: "Select a representation by priority"
        case .responsiveLayout: "Switch structure at a size boundary"
        }
    }

    var symbolName: String {
        switch self {
        case .rigidCard: "rectangle.dashed"
        case .containerFill: "arrow.up.left.and.arrow.down.right"
        case .scaling: "arrow.up.left.and.arrow.down.right.circle"
        case .scrolling: "scroll"
        case .contentSize: "text.word.spacing"
        case .omission: "music.note"
        case .collapsing: "rectangle.compress.vertical"
        case .textAdaptation: "text.alignleft"
        case .viewThatFits: "rectangle.3.group"
        case .responsiveLayout: "rectangle.split.2x1"
        }
    }

    var containerPreset: ContainerSizePreset {
        switch self {
        case .viewThatFits: .viewThatFits
        case .textAdaptation: .textAdaptation
        default: .standard
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .rigidCard: RigidCardExampleView()
        case .containerFill: ContainerFillExampleView()
        case .scaling: ScalingExampleView()
        case .scrolling: ScrollingExampleView()
        case .contentSize: ContentSizeExampleView()
        case .omission: OmissionExampleView()
        case .collapsing: CollapsingExampleView()
        case .textAdaptation: TextAdaptationExampleView()
        case .viewThatFits: ViewThatFitsExampleView()
        case .responsiveLayout: ResponsiveLayoutExampleView()
        }
    }
}

#Preview { ContentView() }
