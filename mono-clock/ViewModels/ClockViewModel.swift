//
//  ClockViewModel.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class ClockViewModel {
    var currentTime: Date = Date()

    @ObservationIgnored
    private var task: Task<Void, Never>?

    private let settings = ClockSettingsStore.shared

    // timeStream is injected
    init(
        timeStream: @escaping () -> AsyncStream<Date> = {
            ClockService.timeStream()
        }
    ) {
        print("ClockViewModel init")
        task = Task { @MainActor in
            for await time in timeStream() {
                currentTime = time
            }
        }
    }

    deinit {
        print("ClockViewModel deinit - cancelling task")
        task?.cancel()
    }

    // MARK: - Computed Properties

    var timeText: String {
        DateFormatterHelper.timeString(
            from: currentTime,
            showSeconds: settings.showSecond,
            format: settings.timeFormat,
            locale: settings.clockLanguage.locale
        )
    }

    var dateText: String {
        DateFormatterHelper.dateString(
            from: currentTime,
            locale: settings.clockLanguage.locale
        )
    }

    // MARK: - Settings Access

    var fontSize: Double {
        settings.fontSize
    }

    var fontFamily: FontFamily {
        settings.fontFamily
    }

    var textColor: Color {
        settings.textColor
    }

    var useMonospacedDigits: Bool {
        settings.useMonospacedDigits
    }

    var position: ClockPosition {
        settings.position
    }

    var clockLanguage: ClockLanguage {
        settings.clockLanguage
    }
}
