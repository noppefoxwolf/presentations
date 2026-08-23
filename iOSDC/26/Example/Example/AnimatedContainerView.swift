//
//  AnimatedContainerView.swift
//  Example
//

import SwiftUI

struct AnimatedContainerView<Content: View>: View {
    @State private var size: ContainerSize = .regular

    private let preset: ContainerSizePreset
    private let content: Content

    init(
        preset: ContainerSizePreset = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.preset = preset
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                ContainerSizePicker(selection: size) { newSize in
                    withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                        size = newSize
                    }
                }

                content
                    .frame(
                        width: preset.width(for: size, availableWidth: proxy.size.width),
                        height: min(preset.height(for: size), proxy.size.height - 80)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.tint.opacity(0.5), lineWidth: 2)
                    }
                    .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
                    .accessibilityLabel("\(size.title) container")

                Text(size.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
        }
    }
}

private struct ContainerSizePicker: View {
    let selection: ContainerSize
    let select: (ContainerSize) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(ContainerSize.allCases) { size in
                Button(size.title) {
                    select(size)
                }
                .buttonStyle(.borderedProminent)
                .tint(selection == size ? .accentColor : .gray)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Container size")
    }
}

enum ContainerSizePreset {
    case standard
    case viewThatFits
    case textAdaptation

    func width(for size: ContainerSize, availableWidth: CGFloat) -> CGFloat {
        if self == .viewThatFits {
            let targetWidth: CGFloat
            switch size {
            case .compact: targetWidth = 48
            case .regular: targetWidth = 120
            case .expanded: targetWidth = 300
            }
            return min(availableWidth, targetWidth)
        }

        let multiplier: CGFloat
        switch (self, size) {
        case (.standard, .compact), (.textAdaptation, .compact): multiplier = 0.5
        case (.standard, .regular), (.textAdaptation, .regular): multiplier = 0.7
        case (.standard, .expanded), (.textAdaptation, .expanded): multiplier = 0.88
        case (.viewThatFits, _): multiplier = 1
        }
        return availableWidth * multiplier
    }

    func height(for size: ContainerSize) -> CGFloat {
        switch (self, size) {
        case (.textAdaptation, .compact): 180
        case (.textAdaptation, .regular): 240
        case (.textAdaptation, .expanded): 320
        default: size.height
        }
    }
}

enum ContainerSize: CaseIterable, Identifiable {
    case compact
    case regular
    case expanded

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .compact: "Compact"
        case .regular: "Regular"
        case .expanded: "Expanded"
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .compact: "A constrained container"
        case .regular: "A medium-sized container"
        case .expanded: "The largest available container"
        }
    }

    var height: CGFloat {
        switch self {
        case .compact: 240
        case .regular: 360
        case .expanded: 520
        }
    }
}

#Preview {
    AnimatedContainerView {
        OmissionExampleView()
    }
}
