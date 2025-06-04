//
//  FilteredButtonStyle.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
//
import SwiftUI

struct FilteredButtonStyle: ButtonStyle {
    var isSelected: Bool
    var status: ApplicationStatus

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? statusColor(status) : Color.gray.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(8)
    }

    private func statusColor(_ status: ApplicationStatus) -> Color {
        switch status {
        case .accepted:
            return .green.opacity(0.6)
        case .pending:
            return .orange.opacity(0.6)
        case .awaitingDocs:
            return .gray.opacity(0.6)
        case .rejected:
            return .red.opacity(0.6)
        }
    }
}
