//
//  AppDelegate.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var clockWindows: [NSWindow] = []
    private var floatingClockWindows: [FloatingClockWindow] = []
    private var settingsWindow: NSWindow?
    private var statusItem: NSStatusItem?

    // UserDefaults キー
    private let showDockIconKey = "showDockIcon"

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Dock アイコン設定を読み込み
        let showDockIcon =
            UserDefaults.standard.object(forKey: showDockIconKey) as? Bool
            ?? false
        applyDockIconSetting(show: showDockIcon)

        // メニューバーアイコンを作成
        setupMenuBarIcon()

        // 時計ウィンドウを作成
        createClockWindows()

        // ディスプレイ構成変更の監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersChanged),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )

        showFloatingClock()

        // 設定ウィンドウ
        settingsWindow = SettingsWindow()
    }

    func applicationWillTerminate(_ notification: Notification) {
        clockWindows.forEach { $0.close() }
        clockWindows.removeAll()

        floatingClockWindows.forEach { $0.close() }
        floatingClockWindows.removeAll()
    }

    // MARK: - Clock Windows

    private func createClockWindows() {
        clockWindows.forEach { $0.close() }
        clockWindows.removeAll()

        for screen in NSScreen.screens {
            let window = ClockWindow(screen: screen)
            clockWindows.append(window)
        }
    }

    @objc private func screenParametersChanged() {
        createClockWindows()
    }

    // MARK: - Menu Bar

    private func setupMenuBarIcon() {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )

        if let button = statusItem?.button {
            button.image = NSImage(
                systemSymbolName: "clock",
                accessibilityDescription: "mono-clock"
            )
        }

        let menu = NSMenu()

        // アプリ情報
        let aboutItem = NSMenuItem(
            title: "mono-clock について",
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        // 壁紙時計の表示/非表示
        let toggleItem = NSMenuItem(
            title: "壁紙時計を隠す",
            action: #selector(toggleClockVisibility),
            keyEquivalent: "h"
        )
        toggleItem.target = self
        menu.addItem(toggleItem)

        // フローティングウィンドウ
        let floatingItem = NSMenuItem(
            title: "ウィンドウで時計を表示",
            action: #selector(showFloatingClock),
            keyEquivalent: "w"
        )
        floatingItem.target = self
        menu.addItem(floatingItem)

        menu.addItem(NSMenuItem.separator())

        // 設定
        let settingsItem = NSMenuItem(
            title: "設定...",
            action: #selector(showSettings),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())

        // Dock アイコン
        let showDockIcon =
            UserDefaults.standard.object(forKey: showDockIconKey) as? Bool
            ?? false
        let dockIconItem = NSMenuItem(
            title: showDockIcon ? "Dock アイコンを隠す" : "Dock アイコンを表示",
            action: #selector(toggleDockIcon),
            keyEquivalent: "d"
        )
        dockIconItem.target = self
        menu.addItem(dockIconItem)

        menu.addItem(NSMenuItem.separator())

        // 終了
        let quitItem = NSMenuItem(
            title: "終了",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    // MARK: - Menu Actions

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "mono-clock"
        alert.informativeText = "デスクトップ壁紙の上に時計を表示するアプリケーション\n\nバージョン 1.0.0"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc private func toggleClockVisibility() {

        guard
            let menuItem = statusItem?.menu?.items.first(where: {
                $0.action == #selector(toggleClockVisibility)
            })
        else {
            return
        }

        // ウィンドウが存在しない、または全て非表示の場合は作成/表示
        if clockWindows.isEmpty || clockWindows.allSatisfy({ !$0.isVisible }) {
            if clockWindows.isEmpty {
                createClockWindows()
            } else {
                clockWindows.forEach { window in
                    window.orderBack(nil)
                }
            }
            menuItem.title = "壁紙時計を隠す"
        } else {
            // ウィンドウを閉じずに非表示にする
            clockWindows.forEach { window in
                window.orderOut(nil)
            }
            menuItem.title = "壁紙時計を表示"
        }
    }

    @objc private func showFloatingClock() {
        let floatingWindow = FloatingClockWindow()

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: floatingWindow,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? FloatingClockWindow
            else { return }
            self?.floatingClockWindows.removeAll { $0 === window }
        }

        floatingClockWindows.append(floatingWindow)
    }

    @objc func showSettings() {
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func toggleDockIcon() {
        let currentSetting =
            UserDefaults.standard.object(forKey: showDockIconKey) as? Bool
            ?? false
        let newSetting = !currentSetting

        UserDefaults.standard.set(newSetting, forKey: showDockIconKey)
        applyDockIconSetting(show: newSetting)

        if let menuItem = statusItem?.menu?.items.first(where: {
            $0.action == #selector(toggleDockIcon)
        }) {
            menuItem.title = newSetting ? "Dock アイコンを隠す" : "Dock アイコンを表示"
        }
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Helpers

    private func applyDockIconSetting(show: Bool) {
        if show {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
