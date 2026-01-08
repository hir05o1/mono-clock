//
//  FloatingClockWindow.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import AppKit
import SwiftUI

final class FloatingClockWindow: NSWindow {

    init() {
        let clockView = ClockView()
        let hostingView = NSHostingView(rootView: clockView)

        // ホスティングビューの適切なサイズを計算
        let fittingSize = hostingView.fittingSize
        let windowHeight = fittingSize.height
        let windowWidth = fittingSize.width

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        // ウィンドウ設定
        titlebarAppearsTransparent = true
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .participatesInCycle]
        isReleasedWhenClosed = false
        titleVisibility = .hidden

        // 初期状態でボタンを非表示にする
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        // ブラー効果を持つVisualEffectViewを作成
        let visualEffectView = NSVisualEffectView(frame: .zero)
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active

        // 黒色半透明のオーバーレイを追加
        let overlayView = NSView(frame: .zero)
        overlayView.wantsLayer = true
        overlayView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.5).cgColor
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.addSubview(overlayView)

        // SwiftUI ビューをセット
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),

            hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
        ])

        contentView = visualEffectView

        // 画面中央に配置
        center()

        // ウィンドウを表示
        makeKeyAndOrderFront(nil)
    }

    override func becomeKey() {
        super.becomeKey()
        // ウィンドウがアクティブになったらボタンを表示
        standardWindowButton(.closeButton)?.isHidden = false
        standardWindowButton(.miniaturizeButton)?.isHidden = false
        standardWindowButton(.zoomButton)?.isHidden = false
    }

    override func resignKey() {
        super.resignKey()
        // ウィンドウが非アクティブになったらボタンを非表示
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
}
