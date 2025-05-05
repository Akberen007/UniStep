//
//  DashboardDataModel.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
import SwiftUI

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

// MARK: - Модель
struct ApplicationData: Identifiable {
    let id = UUID()
    let category: String
    let month: String
    let value: Int
}
