//
//  AdvantageCarouselView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//
//
//import SwiftUI
//
//struct AdvantageCarouselView: View {
//    private let advantageSets: [AdvantageSet] = [
//        AdvantageSet(items: [
//            AdvantageItem(icon: "bolt.fill", title: "Автоматизация заявок"),
//            AdvantageItem(icon: "doc.fill", title: "Генерация документов"),
//            AdvantageItem(icon: "chart.bar.fill", title: "Онлайн аналитика")
//        ]),
//        AdvantageSet(items: [
//            AdvantageItem(icon: "lock.shield.fill", title: "Безопасность данных"),
//            AdvantageItem(icon: "clock.fill", title: "Экономия времени"),
//            AdvantageItem(icon: "network", title: "Интеграции")  // Обратите внимание, что здесь длинный текст
//        ])
//    ]
//
//    @State private var currentSetIndex = 0
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Преимущества UniStep")
//                .font(.headline)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//
//            HStack(spacing: 4) {
//                // Левая стрелка
//                Button(action: {
//                    withAnimation {
//                        currentSetIndex = (currentSetIndex - 1 + advantageSets.count) % advantageSets.count
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.gray)
//                        .font(.title3.bold())
//                        .frame(width: 28, height: 28)
//                }
//
//                HStack(spacing: 12) {
//                    ForEach(advantageSets[currentSetIndex].items) { item in
//                        VStack(spacing: 8) {
//                            Image(systemName: item.icon)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 36, height: 36)
//                                .padding(12)
//                                .background(Color.red.opacity(0.1))
//                                .clipShape(Circle())
//                                .foregroundColor(.red)
//
//                            Text(item.title)
//                                .font(.caption)
//                                .lineLimit(1) // Ограничиваем количество строк
//                                .frame(width: 80) // Уменьшаем ширину, чтобы текст помещался
//                                .fixedSize(horizontal: true, vertical: false) // Принудительно выравниваем по горизонтали
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(width: 100, height: 120)
//                    }
//                }
//
//                // Правая стрелка
//                Button(action: {
//                    withAnimation {
//                        currentSetIndex = (currentSetIndex + 1) % advantageSets.count
//                    }
//                }) {
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray)
//                        .font(.title3.bold())
//                        .frame(width: 28, height: 28)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//#Preview {
//    AdvantageCarouselView()
//}

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
