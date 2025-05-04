//
//  SlideView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

// Структура Slide
struct Slide: Identifiable {
    var id = UUID()  // Уникальный идентификатор
    var title: String
    var subtitle: String
    var image: String
}

struct SlideView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()

    let slides = [
        Slide(title: "Почему UniStep?", subtitle: "Платформа для приёмной кампании — быстро, удобно и эффективно.", image: "questionmark.circle.fill"),
        Slide(title: "Создай цифровую приёмную", subtitle: "Платформа для регистрации вузов в 1 клик", image: "building.columns"),
        Slide(title: "Управляй заявками", subtitle: "Следи за приёмной кампанией в реальном времени", image: "tray.full.fill"),
        Slide(title: "Экономь время", subtitle: "Автоматическая генерация документов и уведомлений", image: "clock.arrow.circlepath")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(Array(slides.enumerated()), id: \.1.id) { index, slide in
                    VStack(spacing: 12) {
                        Image(systemName: slide.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .clipShape(Circle())

                        Text(slide.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(slide.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 250)

            // Индикаторы-сегменты с возможностью кликать
            HStack(spacing: 8) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            currentIndex = index
                        }
                    }) {
                        Capsule()
                            .fill(index == currentIndex ? Color.red : Color.gray.opacity(0.3))
                            .frame(width: 14, height: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 10)
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % slides.count
            }
        }
    }
}

#Preview {
    SlideView()
}
