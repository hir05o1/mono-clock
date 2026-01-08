//
//  SettingsViewModel.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {

    private let store = ClockSettingsStore.shared

    // MARK: - Appearance Settings

    var fontSize: Double {
        get { store.fontSize }
        set { store.fontSize = newValue }
    }

    var fontFamily: FontFamily {
        get { store.fontFamily }
        set { store.fontFamily = newValue }
    }

    var textColor: Color {
        get { store.textColor }
        set { store.textColor = newValue }
    }

    var useMonospacedDigits: Bool {
        get { store.useMonospacedDigits }
        set { store.useMonospacedDigits = newValue }
    }

    var position: ClockPosition {
        get { store.position }
        set { store.position = newValue }
    }

    var clockLanguage: ClockLanguage {
        get { store.clockLanguage }
        set { store.clockLanguage = newValue }
    }

    // MARK: - Time Settings

    var timeFormat: TimeFormat {
        get { store.timeFormat }
        set { store.timeFormat = newValue }
    }

    var showSecond: Bool {
        get { store.showSecond }
        set { store.showSecond = newValue }
    }

    // MARK: - System Settings

    var launchAtLogin: Bool {
        get { store.launchAtLogin }
        set { store.launchAtLogin = newValue }
    }

    // MARK: - Helpers

    var fontSizeRange: ClosedRange<Double> {
        60...400
    }

    func resetToDefaults() {
        fontFamily = FontFamily(name: "Helvetica Neue")
        fontSize = 120
        textColor = .white
        useMonospacedDigits = false
        timeFormat = .hour24
        showSecond = true
        launchAtLogin = false
    }
}

