////
////  DemoDashboardView.swift
////  UniStep
////
////  Created by Akberen on 29.04.2025.
////
//import SwiftUI
//
//struct DemoDashboardView: View {
//    var body: some View {
//        VStack {
//            HStack {
//                Image("logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 120, height: 150)
//                    .padding(.top)
//                
//                Spacer()
//                
//                NotificationBellView(notificationCount: 52)
//                    .frame(width: 40, height: 40)
//            }
//
//            // Сетка карточек
////            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
////                StatCard(title: "Одобрено", value: 50, color: .green)
////                StatCard(title: "На рассмотрении", value: 20, color: .orange)
////                StatCard(title: "Ожидание док-тов", value: 15, color: .gray)
////                StatCard(title: "Отклонено", value: 10, color: .red)
////                StatCard(title: "Всего заявок", value: 100, color: .blue)
////            }
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
//                StatCard(title: "Одобрено", value: 50, total: 100, color: .green) {
//                    print("Tapped: Одобрено")
//                }
//
//                StatCard(title: "На рассмотрении", value: 20, total: 100, color: .orange) {
//                    print("Tapped: На рассмотрении")
//                }
//
//                StatCard(title: "Ожидание док-тов", value: 15, total: 100, color: .gray) {
//                    print("Tapped: Ожидание документов")
//                }
//
//                StatCard(title: "Отклонено", value: 15, total: 100, color: .red) {
//                    print("Tapped: Отклонено")
//                }
//            }
//            .padding(.top)
//
//            Text("Dashboard")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top, 10)
//
//            ProgressBarView(progress: 0.75)
//                .padding(.top, 40)
//
//            Button(action: {
//                // Логика регистрации
//            }) {
//                Text("Зарегистрировать университет")
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding(.top, 40)
//        }
//        .padding(.horizontal, 20)
//    }
//}
//
//struct StatCard: View {
//    var title: String
//    var value: Int
//    var total: Int
//    var color: Color
//    var onTap: () -> Void
//
//    var progress: Double {
//        guard total > 0 else { return 0 }
//        return Double(value) / Double(total)
//    }
//
//    var body: some View {
//        Button(action: {
//            onTap()
//        }) {
//            VStack(spacing: 8) {
//                ZStack {
//                    Circle()
//                        .stroke(color.opacity(0.2), lineWidth: 6)
//                    Circle()
//                        .trim(from: 0, to: progress)
//                        .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
//                        .rotationEffect(.degrees(-90))
//                        .animation(.easeInOut, value: progress)
//
//                    Text("\(value)")
//                        .font(.headline)
//                        .foregroundColor(color)
//                }
//                .frame(width: 50, height: 50)
//
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.7)
//            }
//            .padding()
//            .frame(width: 100, height: 100)
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(radius: 3)
//        }
//    }
//}
//
//#Preview{
//    DemoDashboardView()
//}
//
//struct NotificationBellView: View {
//    var notificationCount: Int
//
//    var body: some View {
//        Image(systemName: "bell")
//            .font(.title)
//            .foregroundColor(.gray) // Цвет иконки
//            .overlay(
//                Text("\(notificationCount)")
//                    .font(.caption2.bold())
//                    .foregroundColor(.white)
//                    .padding(8)
//                    .background(Color.red) // Цвет фона для уведомления
//                    .clipShape(Circle())
//                    .offset(x: 11, y: -12) // Позиционирование числа внутри круга
//            )
//    }
//}
//
//
//
//struct ProgressBarView: View {
//    var progress: Double
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(lineWidth: 12)
//                .opacity(0.1)
//                .foregroundColor(.gray)
//            
//            Circle()
//                .trim(from: 0, to: progress)
//                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
//                .foregroundColor(.red)
//                .rotationEffect(Angle(degrees: -90))
//                .animation(.easeInOut(duration: 1), value: progress)
//            
//            Text("\(Int(progress * 100))%")
//                .font(.headline)
//                .fontWeight(.bold)
//        }
//        .frame(width: 150, height: 150)
//    }
//}

import SwiftUI

// MARK: - Основной экран
struct DemoDashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🔹 Логотип и уведомление
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 150)
                        .padding(.top)

                    Spacer()

                    NotificationBellView(notificationCount: 52)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal)

                // 🔹 Статистика заявок
                VStack(alignment: .leading, spacing: 12) {
                    Text("Статистика заявок")
                        .font(.headline)
                        .foregroundColor(.uniDarkGray)
                        .padding(.leading, 10)

                    HStack(spacing: 12) {
                        StatCard(title: "Одобрено", value: 50, total: 100, color: .uniApproved) {}
                        StatCard(title: "На рассмотрении", value: 20, total: 100, color: .uniPending) {}
                        StatCard(title: "Ожидание док-тов", value: 15, total: 100, color: .uniWaitingDocs) {}
                        StatCard(title: "Отклонено", value: 15, total: 100, color: .uniRejected) {}
                    }
                    .padding(.horizontal, 8)
                }

                // 🔴 Кнопка регистрации
                Button(action: {
                    // Логика регистрации
                }) {
                    Text("Зарегистрировать университет")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.uniRed)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding(.top)
        }
        .background(Color.uniBackground.ignoresSafeArea())
    }
}

// MARK: - Карточка статистики
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
                    .stroke(
                        color.opacity(0.6),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)

                Text("\(value)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color.opacity(0.6))
            }
            .frame(width: 65, height: 65)
            .contentShape(Circle())
            .onTapGesture {
                onTap()
            }

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

// MARK: - Иконка уведомлений
struct NotificationBellView: View {
    var notificationCount: Int

    var body: some View {
        Image(systemName: "bell")
            .font(.title)
            .foregroundColor(.uniTextSecondary)
            .overlay(
                Text("\(notificationCount)")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.uniRed)
                    .clipShape(Circle())
                    .offset(x: 11, y: -12)
            )
    }
}

#Preview {
    DemoDashboardView()
}
