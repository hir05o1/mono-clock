//
//  ClockService.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import Foundation

struct ClockService {

    nonisolated static func timeStream() -> AsyncStream<Date> {
        AsyncStream { continuation in
            var lastDisplayedSecond: Int = -1

            let task = Task {
                while !Task.isCancelled {
                    let now = Date()
                    let currentSecond = Calendar.current.component(
                        .second,
                        from: now
                    )

                    // 秒が変わったときのみ更新
                    if currentSecond != lastDisplayedSecond {
                        continuation.yield(now)
                        lastDisplayedSecond = currentSecond
                    }

                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
