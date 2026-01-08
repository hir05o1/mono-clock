//
//  SettingsView.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import AppKit
import SwiftUI

struct SettingsView: View {

    @State private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            // MARK: - Appearance Section
            Section {
                AppearanceSection(viewModel: viewModel)
            } header: {
                Text(SettingsSection.appearance.title)
            }

            // MARK: - Time Section
            Section {
                TimeSection(viewModel: viewModel)
            } header: {
                Text(SettingsSection.time.title)
            }

            // MARK: - System Section
            Section {
                SystemSection(viewModel: viewModel)
            } header: {
                Text(SettingsSection.system.title)
            }

            // MARK: - Reset Button
            Section {
                Button("デフォルトに戻す") {
                    viewModel.resetToDefaults()
                }
                .foregroundColor(.red)
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 500)
    }
}

// MARK: - Appearance Section

struct AppearanceSection: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Font Size
            VStack(alignment: .leading) {
                Text("フォントサイズ: \(Int(viewModel.fontSize))")
                    .font(.subheadline)
                Slider(
                    value: $viewModel.fontSize,
                    in: viewModel.fontSizeRange,
                    step: 10
                )
            }

            // Font Family
//            Picker("フォントファミリー", selection: $viewModel.fontFamily) {
//                ForEach(FontFamily.all) { family in
//                    Text(family.displayName).tag(family)
//                }
//            }

            // Text Color
            ColorPicker(
                "文字色",
                selection: $viewModel.textColor
            )

            // Monospaced Digits
            Toggle(
                "等幅数字",
                isOn: $viewModel.useMonospacedDigits
            )

            // Position
            Picker("位置", selection: $viewModel.position) {
                ForEach(ClockPosition.allCases) { position in
                    Text(position.displayName).tag(position)
                }
            }

            // TODO: Clock Language
//            Picker("言語", selection: $viewModel.clockLanguage) {
//                ForEach(ClockLanguage.allCases) { language in
//                    Text(language.displayName).tag(language)
//                }
//            }

        }
        .padding(.vertical, 8)
    }
}

// MARK: - Time Section

struct TimeSection: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Time Format
            Picker("表示形式", selection: $viewModel.timeFormat) {
                ForEach(TimeFormat.allCases) { format in
                    Text(format.displayName).tag(format)
                }
            }
            .pickerStyle(.segmented)

            // Show Seconds
            Toggle(
                "秒を表示",
                isOn: $viewModel.showSecond
            )
        }
        .padding(.vertical, 8)
    }
}

// MARK: - System Section

struct SystemSection: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(
                "ログイン時に起動",
                isOn: $viewModel.launchAtLogin
            )
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
