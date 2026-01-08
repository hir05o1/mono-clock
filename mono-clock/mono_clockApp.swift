//
//  mono_clockApp.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import SwiftUI

@main
struct mono_clockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("設定...") {
                    appDelegate.showSettings()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
