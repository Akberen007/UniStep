//
//  AnalyticsChartView.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
//
import SwiftUI
import Charts
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
