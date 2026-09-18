//
//  AdaptationAndFlexibilityExampleView.swift
//  Example
//

import SwiftUI

struct AdaptationAndFlexibilityExampleView: View {
    private let maximumCardWidth: CGFloat = 360

    var body: some View {
        GeometryReader { proxy in
            let availableWidth = max(0, proxy.size.width)
            let horizontalInset: CGFloat = availableWidth < 220 ? 0 : 32
            let horizontalLimit = max(0, availableWidth - horizontalInset)
            let requestedInformationLevel = ArtworkInformationLevel(cardWidth: horizontalLimit)
            let verticalLimit = max(
                0,
                proxy.size.height - requestedInformationLevel.verticalChromeHeight
            )
            let cardWidth = min(horizontalLimit, verticalLimit, maximumCardWidth)
            let informationLevel = ArtworkInformationLevel(cardWidth: cardWidth)
            let hasReachedMaximumWidth = cardWidth == maximumCardWidth

            VStack {
                ArtworkCardView(
                    width: cardWidth,
                    informationLevel: informationLevel,
                    hasReachedMaximumWidth: hasReachedMaximumWidth
                )
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ArtworkCardView: View {
    let width: CGFloat
    let informationLevel: ArtworkInformationLevel
    let hasReachedMaximumWidth: Bool

    var body: some View {
        let artworkWidth = informationLevel == .artworkOnly ? width : max(0, width - 32)

        VStack(alignment: .leading, spacing: 12) {
            ArtworkView()
                .frame(width: artworkWidth, height: artworkWidth)

            if informationLevel != .artworkOnly {
                ArtworkPrimaryInformationView()
            }

            if informationLevel == .artistAndAlbum {
                ArtworkSecondaryInformationView()
            }
        }
        .padding(informationLevel == .artworkOnly ? 0 : 16)
        .frame(width: width, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(hasReachedMaximumWidth ? 0.2 : 0),
            radius: hasReachedMaximumWidth ? 16 : 0,
            y: hasReachedMaximumWidth ? 8 : 0
        )
        .animation(.spring(duration: 0.45, bounce: 0.12), value: width)
        .animation(.spring(duration: 0.35, bounce: 0.1), value: informationLevel)
    }
}

private struct ArtworkView: View {
    var body: some View {
        LinearGradient(
            colors: [.indigo, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            Image(systemName: "music.note")
                .font(.system(size: 64, weight: .medium))
                .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .accessibilityLabel("Midnight City artwork")
    }
}

private struct ArtworkPrimaryInformationView: View {
    var body: some View {
        Text("Midnight City")
            .font(.title2.weight(.semibold))
            .lineLimit(1)
    }
}

private struct ArtworkSecondaryInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("M83")
                .foregroundStyle(.secondary)
            Text("Hurry Up, We're Dreaming")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

private enum ArtworkInformationLevel: Hashable {
    case artworkOnly
    case title
    case artistAndAlbum

    init(cardWidth: CGFloat) {
        switch cardWidth {
        case ..<220: self = .artworkOnly
        case ..<300: self = .title
        default: self = .artistAndAlbum
        }
    }

    var verticalChromeHeight: CGFloat {
        switch self {
        case .artworkOnly: 24
        case .title: 96
        case .artistAndAlbum: 152
        }
    }
}

#Preview {
    AdaptationAndFlexibilityExampleView()
}
