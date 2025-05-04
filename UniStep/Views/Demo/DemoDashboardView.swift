//
//  DemoDashboardView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//
//
import SwiftUI
import Charts

// MARK: - Основной экран
struct DemoDashboardView: View {
    @StateObject private var viewModel = DashboardDataModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 100)
                    Spacer()
                    NotificationBellView(notificationCount: 17)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Статистика заявок")
                        .font(.headline)
                        .foregroundColor(.uniDarkGray)
                        .padding(.leading, 10)

                    let stats = viewModel.stats(for: viewModel.selectedPeriod)
                    let total = viewModel.total(for: viewModel.selectedPeriod)

                    HStack(spacing: 12) {
                        StatCard(title: "Одобрено", value: stats["Одобрено"] ?? 0, total: total, color: .uniApproved) {}
                        StatCard(title: "На рассмотрении", value: stats["На рассмотрении"] ?? 0, total: total, color: .uniPending) {}
                        StatCard(title: "Ожидание док-тов", value: stats["Ожидание док-тов"] ?? 0, total: total, color: .uniWaitingDocs) {}
                        StatCard(title: "Отклонено", value: stats["Отклонено"] ?? 0, total: total, color: .uniRejected) {}
                    }
                    .padding(.horizontal, 8)
                }

                AnalyticsChartView(viewModel: viewModel)

                Button("Зарегистрировать университет") {}
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.uniRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            .padding(.top)
        }
        .background(Color.uniBackground.ignoresSafeArea())
    }
}
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
// MARK: - Диаграмма
struct AnalyticsChartView: View {
    @ObservedObject var viewModel: DashboardDataModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Аналитика заявок по категориям")
                    .font(.headline)
                    .foregroundColor(.uniDarkGray)

                Spacer()

                Menu {
                    ForEach(viewModel.periods, id: \.self) { period in
                        Button {
                            withAnimation {
                                viewModel.selectedPeriod = period
                            }
                        } label: {
                            Text(period)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedPeriod)
                            .font(.caption)
                            .foregroundColor(.uniTextPrimary)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(6)
                }
            }
            .padding(.horizontal)

            Chart(viewModel.dataByPeriod[viewModel.selectedPeriod] ?? []) {
                LineMark(
                    x: .value("Месяц", $0.month),
                    y: .value("Заявки", $0.value),
                    series: .value("Категория", $0.category)
                )
                .symbol(by: .value("Категория", $0.category))
                .foregroundStyle(by: .value("Категория", $0.category))
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: .automatic)
            }
            .frame(height: 250)
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.4), value: viewModel.selectedPeriod)
            .transition(.opacity)
        }
    }
}


// MARK: - Модель
struct ApplicationData: Identifiable {
    let id = UUID()
    let category: String
    let month: String
    let value: Int
}

// MARK: - ViewModel
class DashboardDataModel: ObservableObject {
    @Published var selectedPeriod: String = "Месяц"
    let periods = ["Неделя", "Месяц", "6 мес"]

    let dataByPeriod: [String: [ApplicationData]] = [
        "Неделя": [
            .init(category: "Одобрено", month: "1", value: 58),
            .init(category: "На рассмотрении", month: "1", value: 28),
            .init(category: "Ожидание док-тов", month: "1", value: 18),
            .init(category: "Отклонено", month: "1", value: 10)
        ],
        "Месяц": [
            .init(category: "Одобрено", month: "Апр", value: 130),
            .init(category: "Одобрено", month: "Май", value: 175),
            .init(category: "На рассмотрении", month: "Апр", value: 90),
            .init(category: "На рассмотрении", month: "Май", value: 70),
            .init(category: "Ожидание док-тов", month: "Апр", value: 40),
            .init(category: "Ожидание док-тов", month: "Май", value: 55),
            .init(category: "Отклонено", month: "Апр", value: 25),
            .init(category: "Отклонено", month: "Май", value: 30)
        ],
        "6 мес": [
            .init(category: "Одобрено", month: "Янв", value: 90),
            .init(category: "Одобрено", month: "Фев", value: 105),
            .init(category: "Одобрено", month: "Мар", value: 125),
            .init(category: "Одобрено", month: "Апр", value: 130),
            .init(category: "Одобрено", month: "Май", value: 175),
            .init(category: "Одобрено", month: "Июн", value: 200),
            .init(category: "На рассмотрении", month: "Янв", value: 75),
            .init(category: "На рассмотрении", month: "Фев", value: 65),
            .init(category: "На рассмотрении", month: "Мар", value: 50),
            .init(category: "На рассмотрении", month: "Апр", value: 90),
            .init(category: "На рассмотрении", month: "Май", value: 70),
            .init(category: "На рассмотрении", month: "Июн", value: 60),
            .init(category: "Ожидание док-тов", month: "Янв", value: 30),
            .init(category: "Ожидание док-тов", month: "Фев", value: 35),
            .init(category: "Ожидание док-тов", month: "Мар", value: 42),
            .init(category: "Ожидание док-тов", month: "Апр", value: 40),
            .init(category: "Ожидание док-тов", month: "Май", value: 55),
            .init(category: "Ожидание док-тов", month: "Июн", value: 63),
            .init(category: "Отклонено", month: "Янв", value: 20),
            .init(category: "Отклонено", month: "Фев", value: 22),
            .init(category: "Отклонено", month: "Мар", value: 18),
            .init(category: "Отклонено", month: "Апр", value: 25),
            .init(category: "Отклонено", month: "Май", value: 30),
            .init(category: "Отклонено", month: "Июн", value: 28)
        ]
    ]

    func stats(for period: String) -> [String: Int] {
        let data = dataByPeriod[period] ?? []
        return Dictionary(grouping: data, by: { $0.category })
            .mapValues { $0.map { $0.value }.reduce(0, +) }
    }

    func total(for period: String) -> Int {
        dataByPeriod[period]?.map { $0.value }.reduce(0, +) ?? 0
    }
}


#Preview{
    DemoDashboardView()
}
