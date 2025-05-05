//
//  StatCard.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
//
import SwiftUI

// MARK: - Карточка статистики
// MARK: - UI элементы
struct StatCard: View {
    var title: String
    var value: Int
    var total: Int
    var color: Color
    var onTap: () -> Void

    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(value) / Double(total)
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 6)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color.opacity(0.6), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                Text("\(value)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color.opacity(0.6))
            }
            .frame(width: 65, height: 65)
            .onTapGesture { onTap() }

            Text(title)
                .font(.caption2)
                .foregroundColor(Color.uniTextPrimary.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .padding(.top, 6)
        }
        .frame(width: 72)
    }
}
