//
//  ClockWindow.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import AppKit
import SwiftUI

final class ClockWindow: NSWindow {

    init(screen: NSScreen) {
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        // ウィンドウ設定（壁紙レベル）
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        ignoresMouseEvents = true  // マウスイベントを透過

        // スクリーンに配置
        setFrame(screen.frame, display: true)
        orderBack(nil)

        // SwiftUI ビューをセット（枠なし設定）
        let hostingView = NSHostingView(rootView: ClockView())
        hostingView.layer?.backgroundColor = .clear
        contentView = hostingView
    }
}
