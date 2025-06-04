//
//  DashboardDataModel.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import Foundation
import SwiftUI

// MARK: - Data Models
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let month: String
    let value: Int
    let category: String
}

// MARK: - Dashboard Data Model
class DashboardDataModel: ObservableObject {
    @Published var selectedPeriod = "За месяц"
    @Published var periods = ["За неделю", "За месяц", "За квартал", "За год"]
    @Published var dataByPeriod: [String: [ChartDataPoint]] = [:]
    
    init() {
        setupMockData()
    }
    
    // MARK: - Mock Data Setup
    private func setupMockData() {
        // Данные за неделю
        dataByPeriod["За неделю"] = [
            ChartDataPoint(month: "Пн", value: 15, category: "IT"),
            ChartDataPoint(month: "Вт", value: 23, category: "IT"),
            ChartDataPoint(month: "Ср", value: 18, category: "IT"),
            ChartDataPoint(month: "Чт", value: 32, category: "IT"),
            ChartDataPoint(month: "Пт", value: 28, category: "IT"),
            ChartDataPoint(month: "Сб", value: 12, category: "IT"),
            ChartDataPoint(month: "Вс", value: 8, category: "IT"),
            
            ChartDataPoint(month: "Пн", value: 8, category: "Медицинские"),
            ChartDataPoint(month: "Вт", value: 12, category: "Медицинские"),
            ChartDataPoint(month: "Ср", value: 10, category: "Медицинские"),
            ChartDataPoint(month: "Чт", value: 15, category: "Медицинские"),
            ChartDataPoint(month: "Пт", value: 14, category: "Медицинские"),
            ChartDataPoint(month: "Сб", value: 6, category: "Медицинские"),
            ChartDataPoint(month: "Вс", value: 4, category: "Медицинские"),
            
            ChartDataPoint(month: "Пн", value: 12, category: "Экономические"),
            ChartDataPoint(month: "Вт", value: 18, category: "Экономические"),
            ChartDataPoint(month: "Ср", value: 14, category: "Экономические"),
            ChartDataPoint(month: "Чт", value: 22, category: "Экономические"),
            ChartDataPoint(month: "Пт", value: 19, category: "Экономические"),
            ChartDataPoint(month: "Сб", value: 9, category: "Экономические"),
            ChartDataPoint(month: "Вс", value: 5, category: "Экономические")
        ]
        
        // Данные за месяц
        dataByPeriod["За месяц"] = [
            ChartDataPoint(month: "1 нед", value: 45, category: "IT"),
            ChartDataPoint(month: "2 нед", value: 52, category: "IT"),
            ChartDataPoint(month: "3 нед", value: 38, category: "IT"),
            ChartDataPoint(month: "4 нед", value: 61, category: "IT"),
            
            ChartDataPoint(month: "1 нед", value: 28, category: "Медицинские"),
            ChartDataPoint(month: "2 нед", value: 35, category: "Медицинские"),
            ChartDataPoint(month: "3 нед", value: 22, category: "Медицинские"),
            ChartDataPoint(month: "4 нед", value: 41, category: "Медицинские"),
            
            ChartDataPoint(month: "1 нед", value: 33, category: "Экономические"),
            ChartDataPoint(month: "2 нед", value: 29, category: "Экономические"),
            ChartDataPoint(month: "3 нед", value: 44, category: "Экономические"),
            ChartDataPoint(month: "4 нед", value: 37, category: "Экономические"),
            
            ChartDataPoint(month: "1 нед", value: 18, category: "Технические"),
            ChartDataPoint(month: "2 нед", value: 24, category: "Технические"),
            ChartDataPoint(month: "3 нед", value: 16, category: "Технические"),
            ChartDataPoint(month: "4 нед", value: 31, category: "Технические")
        ]
        
        // Данные за квартал
        dataByPeriod["За квартал"] = [
            ChartDataPoint(month: "Янв", value: 142, category: "IT"),
            ChartDataPoint(month: "Фев", value: 156, category: "IT"),
            ChartDataPoint(month: "Мар", value: 189, category: "IT"),
            
            ChartDataPoint(month: "Янв", value: 89, category: "Медицинские"),
            ChartDataPoint(month: "Фев", value: 97, category: "Медицинские"),
            ChartDataPoint(month: "Мар", value: 112, category: "Медицинские"),
            
            ChartDataPoint(month: "Янв", value: 76, category: "Экономические"),
            ChartDataPoint(month: "Фев", value: 83, category: "Экономические"),
            ChartDataPoint(month: "Мар", value: 95, category: "Экономические"),
            
            ChartDataPoint(month: "Янв", value: 54, category: "Технические"),
            ChartDataPoint(month: "Фев", value: 61, category: "Технические"),
            ChartDataPoint(month: "Мар", value: 68, category: "Технические"),
            
            ChartDataPoint(month: "Янв", value: 32, category: "Гуманитарные"),
            ChartDataPoint(month: "Фев", value: 28, category: "Гуманитарные"),
            ChartDataPoint(month: "Мар", value: 35, category: "Гуманитарные")
        ]
        
        // Данные за год
        dataByPeriod["За год"] = [
            ChartDataPoint(month: "Янв", value: 245, category: "IT"),
            ChartDataPoint(month: "Фев", value: 278, category: "IT"),
            ChartDataPoint(month: "Мар", value: 312, category: "IT"),
            ChartDataPoint(month: "Апр", value: 289, category: "IT"),
            ChartDataPoint(month: "Май", value: 356, category: "IT"),
            ChartDataPoint(month: "Июн", value: 423, category: "IT"),
            ChartDataPoint(month: "Июл", value: 398, category: "IT"),
            ChartDataPoint(month: "Авг", value: 367, category: "IT"),
            ChartDataPoint(month: "Сен", value: 445, category: "IT"),
            ChartDataPoint(month: "Окт", value: 512, category: "IT"),
            ChartDataPoint(month: "Ноя", value: 478, category: "IT"),
            ChartDataPoint(month: "Дек", value: 389, category: "IT"),
            
            ChartDataPoint(month: "Янв", value: 156, category: "Медицинские"),
            ChartDataPoint(month: "Фев", value: 167, category: "Медицинские"),
            ChartDataPoint(month: "Мар", value: 189, category: "Медицинские"),
            ChartDataPoint(month: "Апр", value: 145, category: "Медицинские"),
            ChartDataPoint(month: "Май", value: 201, category: "Медицинские"),
            ChartDataPoint(month: "Июн", value: 234, category: "Медицинские"),
            ChartDataPoint(month: "Июл", value: 212, category: "Медицинские"),
            ChartDataPoint(month: "Авг", value: 189, category: "Медицинские"),
            ChartDataPoint(month: "Сен", value: 267, category: "Медицинские"),
            ChartDataPoint(month: "Окт", value: 298, category: "Медицинские"),
            ChartDataPoint(month: "Ноя", value: 278, category: "Медицинские"),
            ChartDataPoint(month: "Дек", value: 234, category: "Медицинские"),
            
            ChartDataPoint(month: "Янв", value: 134, category: "Экономические"),
            ChartDataPoint(month: "Фев", value: 145, category: "Экономические"),
            ChartDataPoint(month: "Мар", value: 167, category: "Экономические"),
            ChartDataPoint(month: "Апр", value: 123, category: "Экономические"),
            ChartDataPoint(month: "Май", value: 178, category: "Экономические"),
            ChartDataPoint(month: "Июн", value: 198, category: "Экономические"),
            ChartDataPoint(month: "Июл", value: 187, category: "Экономические"),
            ChartDataPoint(month: "Авг", value: 156, category: "Экономические"),
            ChartDataPoint(month: "Сен", value: 213, category: "Экономические"),
            ChartDataPoint(month: "Окт", value: 245, category: "Экономические"),
            ChartDataPoint(month: "Ноя", value: 234, category: "Экономические"),
            ChartDataPoint(month: "Дек", value: 189, category: "Экономические")
        ]
    }
    
    // MARK: - Helper Methods
    func getTotalApplications(for period: String) -> Int {
        guard let data = dataByPeriod[period] else { return 0 }
        return data.reduce(0) { $0 + $1.value }
    }
    
    func getTopCategory(for period: String) -> String {
        guard let data = dataByPeriod[period] else { return "IT" }
        
        let categoryTotals = Dictionary(grouping: data, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.value } }
        
        return categoryTotals.max(by: { $0.value < $1.value })?.key ?? "IT"
    }
    
    func getCategoryTotal(category: String, for period: String) -> Int {
        guard let data = dataByPeriod[period] else { return 0 }
        return data.filter { $0.category == category }.reduce(0) { $0 + $1.value }
    }
}
