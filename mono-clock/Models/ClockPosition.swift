//
//  ClockPosition.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import SwiftUI

enum ClockPosition: String, CaseIterable, Identifiable {
    case topLeading = "topLeading"
    case top = "top"
    case topTrailing = "topTrailing"
    case leading = "leading"
    case center = "center"
    case trailing = "trailing"
    case bottomLeading = "bottomLeading"
    case bottom = "bottom"
    case bottomTrailing = "bottomTrailing"

    var id: String { rawValue }

    // MARK: - Display Properties
    var displayName: String {
        switch self {
        case .topLeading: return "左上"
        case .top: return "上"
        case .topTrailing: return "右上"
        case .leading: return "左"
        case .center: return "中央"
        case .trailing: return "右"
        case .bottomLeading: return "左下"
        case .bottom: return "下"
        case .bottomTrailing: return "右下"
        }
    }

    // MARK: - Layout Properties
    var alignment: Alignment {
        switch self {
        case .topLeading: return .topLeading
        case .top: return .top
        case .topTrailing: return .topTrailing
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        case .bottomLeading: return .bottomLeading
        case .bottom: return .bottom
        case .bottomTrailing: return .bottomTrailing
        }
    }

    var defaultMargin: EdgeInsets {
        switch self {
        case .topLeading, .topTrailing, .bottomLeading, .bottomTrailing:
            return EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
        case .top, .bottom:
            return EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20)
        case .leading, .trailing:
            return EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40)
        case .center:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }

    // MARK: - Grid Properties
    var gridPosition: (row: Int, column: Int) {
        switch self {
        case .topLeading: return (0, 0)
        case .top: return (0, 1)
        case .topTrailing: return (0, 2)
        case .leading: return (1, 0)
        case .center: return (1, 1)
        case .trailing: return (1, 2)
        case .bottomLeading: return (2, 0)
        case .bottom: return (2, 1)
        case .bottomTrailing: return (2, 2)
        }
    }

    static func from(row: Int, column: Int) -> ClockPosition {
        switch (row, column) {
        case (0, 0): return .topLeading
        case (0, 1): return .top
        case (0, 2): return .topTrailing
        case (1, 0): return .leading
        case (1, 1): return .center
        case (1, 2): return .trailing
        case (2, 0): return .bottomLeading
        case (2, 1): return .bottom
        case (2, 2): return .bottomTrailing
        default: return .center
        }
    }

}
