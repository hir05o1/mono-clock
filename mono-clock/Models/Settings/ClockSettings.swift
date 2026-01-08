//
//  ClockSettings.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import SwiftUI

enum SettingsKey: String, CaseIterable, Identifiable {
    case fontSize
    case fontFamily
    case textColor
    case useMonospacedDigits
    case position
    case clockLanguage
    case timeFormat
    case showSecond
    case launchAtLogin

    var id: String { rawValue }
}

enum SettingsSection: String, CaseIterable, Identifiable {

    case appearance
    case time
    case system

    // Identifiable
    var id: String { rawValue }

    // UI 表示名
    var title: String {
        switch self {
        case .appearance:
            return "表示"
        case .time:
            return "時刻"
        case .system:
            return "システム"
        }
    }
}

struct SettingsItem: Identifiable {
    let key: SettingsKey
    let section: SettingsSection
    let title: String

    var id: SettingsKey { key }
}

extension SettingsItem {

    static let all: [SettingsItem] = [
        // MARK: Appearance
        .init(
            key: .fontSize,
            section: .appearance,
            title: "フォントサイズ"
        ),
        .init(
            key: .fontFamily,
            section: .appearance,
            title: "フォントファミリー"
        ),
        .init(
            key: .textColor,
            section: .appearance,
            title: "文字色"
        ),
        .init(
            key: .useMonospacedDigits,
            section: .appearance,
            title: "等幅数字"
        ),
        .init(
            key: .position,
            section: .appearance,
            title: "位置"
        ),
        .init (
            key: .clockLanguage,
            section: .system,
            title: "時計の言語の切り替え"
        ),

        // MARK: Time
        .init(
            key: .timeFormat,
            section: .time,
            title: "表示形式"
        ),
        .init(
            key: .showSecond,
            section: .time,
            title: "秒を表示"
        ),

        // MARK: System
        .init(
            key: .launchAtLogin,
            section: .system,
            title: "ログイン時に起動"
        ),
    ]
}
