//
//  WidgetTargetControl.swift
//  WidgetTarget
//
//  Created by Tomoya Hirano on 2024/06/23.
//

import AppIntents
import SwiftUI
import WidgetKit

struct WidgetTargetControl: ControlWidget {
    static let kind: String = "dev.noppe.Example.WidgetTarget"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name),
                valueLabel: { isRunning in
                    Label(isRunning ? "On" : "Off", systemImage: "timer")
                }
            )
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
    }
}

extension WidgetTargetControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            WidgetTargetControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return WidgetTargetControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static var title: LocalizedStringResource { "Timer Name Configuration" }

    @Parameter(title: "Timer Name")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static var title: LocalizedStringResource { "Start a timer" }

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}
