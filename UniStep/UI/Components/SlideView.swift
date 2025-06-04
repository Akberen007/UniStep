//
//  SlideView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

// Структура Slide
//struct Slide: Identifiable {
//    var id = UUID()  // Уникальный идентификатор
//    var title: String
//    var subtitle: String
//    var image: String
//    var gradient: LinearGradient
//}

struct SlideView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    let slides = [
        Slide(
            title: "🎓 Поступи в 2025!",
            subtitle: "150+ университетов ждут твою заявку. Подача за 5 минут!",
            image: "graduationcap.fill",
            gradient: LinearGradient(
                colors: [Color.red, Color.pink.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        Slide(
            title: "⚡ Быстро и просто",
            subtitle: "Без очередей и бумажной волокиты. Все онлайн!",
            image: "bolt.circle.fill",
            gradient: LinearGradient(
                colors: [Color.orange, Color.yellow.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        Slide(
            title: "📱 Отслеживай статус",
            subtitle: "Получай уведомления о каждом этапе рассмотрения",
            image: "bell.badge.fill",
            gradient: LinearGradient(
                colors: [Color.blue, Color.cyan.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ),
        Slide(
            title: "🏆 Уже 1,247 заявок!",
            subtitle: "Присоединяйся к тысячам абитуриентов по всему Казахстану",
            image: "chart.line.uptrend.xyaxis.circle.fill",
            gradient: LinearGradient(
                colors: [Color.green, Color.mint.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(Array(slides.enumerated()), id: \.1.id) { index, slide in
                    ZStack {
                        // Градиентный фон с закругленными углами
                        RoundedRectangle(cornerRadius: 16)
                            .fill(slide.gradient)
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(slide.title)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)

                                Text(slide.subtitle)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: slide.image)
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 160)

            // Индикаторы одинакового размера
            HStack(spacing: 6) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentIndex = index
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(index == currentIndex ? Color.red : Color.gray.opacity(0.4))
                            .frame(width: 16, height: 4)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(Color.clear)
        .onReceive(timer) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentIndex = (currentIndex + 1) % slides.count
            }
        }
    }
}

#Preview {
    SlideView()
}
