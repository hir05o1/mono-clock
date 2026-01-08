//
//  ClockLanguage.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation

enum ClockLanguage: String, CaseIterable, Identifiable {
    // rawValueは保存用（UserDefaultsなど）に使います
    case system = "system"
    case english = "en_US"
    case japanese = "ja_JP"

    var id: String { rawValue }

    // MARK: - Display Properties

    // 設定画面のピッカーに表示する名前
    var displayName: String {
        switch self {
        case .system: return "システム設定に従う"
        case .english: return "English"
        case .japanese: return "日本語"
        }
    }

    // MARK: - Core Logic

    // 実際にDateFormatterに渡すLocale情報
    var locale: Locale {
        switch self {
        case .system:
            // ユーザーのMacの現在の設定を返す（自動更新対応）
            return .autoupdatingCurrent
        case .english:
            // 米国英語（"Sunday, January 1" のような表記用）
            return Locale(identifier: self.rawValue)
        case .japanese:
            // 日本語（"1月1日 日曜日" のような表記用）
            return Locale(identifier: self.rawValue)
        }
    }
}
