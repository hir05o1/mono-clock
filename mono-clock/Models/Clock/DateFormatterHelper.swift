//
//  DateFormatterHelper.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation

enum DateFormatterHelper {

    private nonisolated(unsafe) static var formatterCache:
        [String: DateFormatter] = [:]
    private static let lock = NSLock()

    static func dateString(from date: Date, locale: Locale) -> String {
        let formatString = buildDateFormat()
        let formatter = getOrCreateFormatter(
            for: formatString,
            locale: locale
        )
        return formatter.string(from: date)
    }

    static func timeString(
        from date: Date,
        showSeconds: Bool,
        format: TimeFormat,
        locale: Locale
    ) -> String {
        let formatString = buildTimeFormat(
            showSeconds: showSeconds,
            format: format
        )
        let formatter = getOrCreateFormatter(for: formatString, locale: locale)
        return formatter.string(from: date)
    }

    private static func buildDateFormat() -> String {
        return "yyyy年MM月dd日 EEEE"
    }

    private static func buildTimeFormat(showSeconds: Bool, format: TimeFormat)
        -> String
    {
        switch format {
        case .hour24:
            return showSeconds ? "HH:mm:ss" : "HH:mm"
        case .hour12:
            return showSeconds ? "hh:mm:ss a" : "hh:mm a"
        }
    }

    // MARK: - Formatter Cache

    private static func getOrCreateFormatter(
        for formatString: String,
        locale: Locale
    ) -> DateFormatter {
        lock.lock()
        defer { lock.unlock() }

        // キャッシュにあれば返す
//        if let cached = formatterCache[formatString] {
//            return cached
//        }

        // なければ新規作成してキャッシュ
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.dateFormat = formatString

        formatterCache[formatString] = formatter
        return formatter
    }

    // キャッシュをクリアする（必要に応じて使用）
    static func clearCache() {
        lock.lock()
        defer { lock.unlock() }
        formatterCache.removeAll()
    }
}
