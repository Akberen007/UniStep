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

#Preview{
    DemoDashboardView()
}
