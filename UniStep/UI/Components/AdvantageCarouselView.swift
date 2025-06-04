//
//  AdvantageCarouselView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

struct AdvantageCarouselView: View {
    let steps: [(icon: String, title: String)] = [
        ("person.crop.circle.badge.plus", "Регистрация"),
        ("globe", "Создание сайта"),
        ("envelope.badge", "Приём заявок"),
        ("chart.bar.doc.horizontal", "Аналитика")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Как работает UniStep")
                .font(.headline)
                .padding(.horizontal)

            GeometryReader { geometry in
                let itemWidth = (geometry.size.width - 60) / CGFloat(steps.count)

                HStack(alignment: .top, spacing: 12) {
                    ForEach(steps.indices, id: \.self) { index in
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 50, height: 50)

                                Image(systemName: steps[index].icon)
                                    .font(.system(size: 22))
                                    .foregroundColor(.red)
                            }

                            Text(steps[index].title)
                                .font(.caption)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .frame(width: itemWidth)
                        }

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 12, height: 2)
                                .offset(y: 25)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 100)
        }
        .padding(.vertical, 10)
    }
}
