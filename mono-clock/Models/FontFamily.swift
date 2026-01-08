//
//  FontFamily.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import AppKit

struct FontFamily: Hashable, Identifiable, Codable {
    let name: String

    var id: String { name }

    // 表示名
    var displayName: String { name }

    // システムで利用可能なフォントファミリー一覧
    static var all: [FontFamily] {
        NSFontManager.shared.availableFontFamilies
            .sorted()
            .map { FontFamily(name: $0) }
    }
}
