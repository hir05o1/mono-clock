//
//  ClockView.swift
//  mono-clock
//
//  Created by hiro on 2026/01/06.
//

import SwiftUI

struct ClockView: View {
    @State private var viewModel = ClockViewModel()

    var body: some View {
        ZStack(alignment: viewModel.position.alignment) {
            // 透明背景（壁紙を透過表示）
            Color.clear
                .ignoresSafeArea(.all, edges: .all)

            VStack(spacing: 20) {
                // 時刻表示
                Text(viewModel.timeText)
                    .font(
                        viewModel.useMonospacedDigits
                            ? .system(size: viewModel.fontSize, weight: .thin)
                            .monospacedDigit()
                            : .system(size: viewModel.fontSize, weight: .thin)
                    )
                    .foregroundColor(viewModel.textColor)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

                // 日付表示
                Text(viewModel.dateText)
                    .font(.system(size: viewModel.fontSize / 3.3, weight: .light))
                    .foregroundColor(viewModel.textColor.opacity(0.9))
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
            }
            .padding(viewModel.position.defaultMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: viewModel.position.alignment)
        .background(.clear)
        .ignoresSafeArea(.all, edges: .all)
    }
}

#Preview {
    ClockView()
        .frame(width: 800, height: 600)
        .background(Color.blue.opacity(0.3))
}
