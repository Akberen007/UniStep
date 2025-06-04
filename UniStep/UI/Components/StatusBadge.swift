//
//  StatusBadge.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
//
import SwiftUI

// Статус для заявки
struct StatusBadge: View {
    var status: ApplicationStatus

    var body: some View {
        Circle()
            .fill(statusColor(status))  // Круг, цвет зависит от статуса
            .frame(width: 10, height: 10)
    }
    
    func statusColor(_ status: ApplicationStatus) -> Color {
        switch status {
        case .accepted:
            return .green // Зеленый для "Принято"
        case .pending:
            return .orange // Оранжевый для "На рассмотрении"
        case .awaitingDocs:
            return .gray // Серый для "Ожидание документов"
        case .rejected:
            return .red // Красный для "Отклонено"
        }
    }
}
