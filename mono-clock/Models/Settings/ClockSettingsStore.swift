//
//  ClockSettingsStore.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class ClockSettingsStore {

    static let shared = ClockSettingsStore()

    // MARK: - Appearance Settings
    var fontSize: Double {
        didSet {
            UserDefaults.standard.set(
                fontSize,
                forKey: SettingsKey.fontSize.rawValue
            )
        }
    }

    var fontFamily: FontFamily {
        didSet {
            UserDefaults.standard.set(
                fontFamily.name,
                forKey: SettingsKey.fontFamily.rawValue
            )
        }
    }

    var textColor: Color {
        didSet { saveColor(textColor, forKey: SettingsKey.textColor.rawValue) }
    }

    var useMonospacedDigits: Bool {
        didSet {
            UserDefaults.standard.set(
                useMonospacedDigits,
                forKey: SettingsKey.useMonospacedDigits.rawValue
            )
        }
    }

    var position: ClockPosition {
        didSet {
            UserDefaults.standard.set(
                position,
                forKey: SettingsKey.position.rawValue
            )
        }
    }

    var clockLanguage: ClockLanguage {
        didSet {
            UserDefaults.standard.set(
                clockLanguage,
                forKey: SettingsKey.clockLanguage.rawValue
            )
        }
    }

    // MARK: - Time Settings
    var timeFormat: TimeFormat {
        didSet {
            UserDefaults.standard.set(
                timeFormat.rawValue,
                forKey: SettingsKey.timeFormat.rawValue
            )
        }
    }

    var showSecond: Bool {
        didSet {
            UserDefaults.standard.set(
                showSecond,
                forKey: SettingsKey.showSecond.rawValue
            )
        }
    }

    // MARK: - System Settings
    var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(
                launchAtLogin,
                forKey: SettingsKey.launchAtLogin.rawValue
            )
        }
    }

    private init() {
        // Appearance
        self.fontSize = UserDefaults.standard.double(
            forKey: SettingsKey.fontSize.rawValue
        ).orDefault(120)
        let savedFamily =
            UserDefaults.standard.string(
                forKey: SettingsKey.fontFamily.rawValue
            ) ?? "Helvetica Neue"
        self.fontFamily = FontFamily(name: savedFamily)
        self.textColor =
            Self.loadColor(forKey: SettingsKey.textColor.rawValue) ?? .white
        self.useMonospacedDigits = UserDefaults.standard.bool(
            forKey: SettingsKey.useMonospacedDigits.rawValue
        )
        let positionRawValue = UserDefaults.standard.string(
            forKey: SettingsKey.position.rawValue
        )
        self.position =
            ClockPosition(rawValue: positionRawValue ?? "") ?? .center
        self.clockLanguage =
            ClockLanguage(
                rawValue: UserDefaults.standard.string(
                    forKey: SettingsKey.clockLanguage.rawValue
                ) ?? ""
            ) ?? .system

        // Time
        let formatRawValue = UserDefaults.standard.string(
            forKey: SettingsKey.timeFormat.rawValue
        )
        self.timeFormat = TimeFormat(rawValue: formatRawValue ?? "") ?? .hour24
        self.showSecond = UserDefaults.standard.bool(
            forKey: SettingsKey.showSecond.rawValue,
            default: true
        )

        // System
        self.launchAtLogin = UserDefaults.standard.bool(
            forKey: SettingsKey.launchAtLogin.rawValue
        )
    }

    // MARK: - Color Persistence

    private func saveColor(_ color: Color, forKey key: String) {
        let nsColor = NSColor(color)
        if let data = try? NSKeyedArchiver.archivedData(
            withRootObject: nsColor,
            requiringSecureCoding: false
        ) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func loadColor(forKey key: String) -> Color? {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let nsColor = try? NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(data) as? NSColor
        else { return nil }
        return Color(nsColor)
    }
}

// MARK: - TimeFormat

enum TimeFormat: String, CaseIterable, Identifiable {
    case hour24 = "24h"
    case hour12 = "12h"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hour24: return "24時間"
        case .hour12: return "12時間"
        }
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    fileprivate func bool(forKey key: String, default defaultValue: Bool)
        -> Bool
    {
        if object(forKey: key) == nil {
            return defaultValue
        }
        return bool(forKey: key)
    }
}

extension Double {
    fileprivate func orDefault(_ defaultValue: Double) -> Double {
        self == 0 ? defaultValue : self
    }
}
