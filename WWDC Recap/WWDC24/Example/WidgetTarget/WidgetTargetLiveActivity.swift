//
//  WidgetTargetLiveActivity.swift
//  WidgetTarget
//
//  Created by Tomoya Hirano on 2024/06/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetTargetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetTargetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetTargetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetTargetAttributes {
    fileprivate static var preview: WidgetTargetAttributes {
        WidgetTargetAttributes(name: "World")
    }
}

extension WidgetTargetAttributes.ContentState {
    fileprivate static var smiley: WidgetTargetAttributes.ContentState {
        WidgetTargetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetTargetAttributes.ContentState {
         WidgetTargetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetTargetAttributes.preview) {
   WidgetTargetLiveActivity()
} contentStates: {
    WidgetTargetAttributes.ContentState.smiley
    WidgetTargetAttributes.ContentState.starEyes
}
