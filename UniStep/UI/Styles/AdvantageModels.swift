//
//  AdvantageModels.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//

import Foundation

// Модель для одного элемента с иконкой и заголовком
struct AdvantageItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

// Модель для набора преимущесфтв
struct AdvantageSet {
    let items: [AdvantageItem]
}
