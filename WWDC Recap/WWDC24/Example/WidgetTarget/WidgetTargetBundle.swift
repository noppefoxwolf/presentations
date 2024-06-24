//
//  WidgetTargetBundle.swift
//  WidgetTarget
//
//  Created by Tomoya Hirano on 2024/06/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetTargetBundle: WidgetBundle {
    var body: some Widget {
        WidgetTarget()
        WidgetTargetControl()
        WidgetTargetLiveActivity()
    }
}
