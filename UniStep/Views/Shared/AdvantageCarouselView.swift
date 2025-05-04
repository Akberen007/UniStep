//
//  AdvantageCarouselView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

struct AdvantageCarouselView: View {
    private let advantageSets: [AdvantageSet] = [
        AdvantageSet(items: [
            AdvantageItem(icon: "bolt.fill", title: "Автоматизация заявок"),
            AdvantageItem(icon: "doc.fill", title: "Генерация документов"),
            AdvantageItem(icon: "chart.bar.fill", title: "Онлайн аналитика")
        ]),
        AdvantageSet(items: [
            AdvantageItem(icon: "lock.shield.fill", title: "Безопасность данных"),
            AdvantageItem(icon: "clock.fill", title: "Экономия времени"),
            AdvantageItem(icon: "network", title: "Интеграции")  // Обратите внимание, что здесь длинный текст
        ])
    ]

    @State private var currentSetIndex = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Преимущества UniStep")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            HStack(spacing: 4) {
                // Левая стрелка
                Button(action: {
                    withAnimation {
                        currentSetIndex = (currentSetIndex - 1 + advantageSets.count) % advantageSets.count
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .font(.title3.bold())
                        .frame(width: 28, height: 28)
                }

                HStack(spacing: 12) {
                    ForEach(advantageSets[currentSetIndex].items) { item in
                        VStack(spacing: 8) {
                            Image(systemName: item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .clipShape(Circle())
                                .foregroundColor(.red)

                            Text(item.title)
                                .font(.caption)
                                .lineLimit(1) // Ограничиваем количество строк
                                .frame(width: 80) // Уменьшаем ширину, чтобы текст помещался
                                .fixedSize(horizontal: true, vertical: false) // Принудительно выравниваем по горизонтали
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 100, height: 120)
                    }
                }

                // Правая стрелка
                Button(action: {
                    withAnimation {
                        currentSetIndex = (currentSetIndex + 1) % advantageSets.count
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.title3.bold())
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AdvantageCarouselView()
}
