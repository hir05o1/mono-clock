//
//  SettingsWindow.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import AppKit
import SwiftUI

final class SettingsWindow: NSWindow {

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        title = "設定"
        isReleasedWhenClosed = false
        center()

        contentView = NSHostingView(
            rootView: SettingsView()
        )
    }
}
