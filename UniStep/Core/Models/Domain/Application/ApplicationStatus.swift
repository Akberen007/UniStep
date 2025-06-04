
//
//  ApplicationStatus.swift
//  UniStep
//
//  Created by Akberen on 28.05.2025.
//

import SwiftUI

// MARK: - Application Status
enum ApplicationStatus: String, CaseIterable, Codable {
    case accepted = "accepted"
    case pending = "pending"
    case awaitingDocs = "awaiting_docs"
    case rejected = "rejected"
    
    // MARK: - Display Properties (для UI)
    var displayName: String {
        switch self {
        case .accepted:
            return "Принято"
        case .pending:
            return "На рассмотрении"
        case .awaitingDocs:
            return "Ожидание документов"
        case .rejected:
            return "Отклонено"
        }
    }
    
    // MARK: - UI Colors
    var color: Color {
        switch self {
        case .accepted:
            return .green
        case .pending:
            return .orange
        case .awaitingDocs:
            return .blue
        case .rejected:
            return .red
        }
    }
}
// MARK: - Supporting Views

struct StepHeader: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Красивая иконка с градиентом и анимацией
            ZStack {
                // Внешний круг с градиентом
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.red.opacity(0.8), Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .red.opacity(0.3), radius: 12, x: 0, y: 6)
                
                // Внутренний круг
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 64, height: 64)
                
                // Иконка
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CustomPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: getSystemImage(for: title))
                .foregroundColor(.gray)
                .frame(width: 20, height: 20)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        HStack {
                            Text(option)
                            Spacer()
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? title : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .frame(height: 48)
        .padding(.horizontal)
    }
    
    private func getSystemImage(for title: String) -> String {
        switch title {
        case "Университет":
            return "building.columns"
        case "Факультет":
            return "graduationcap"
        case "Язык обучения":
            return "globe"
        case "Форма обучения":
            return "clock"
        default:
            return "chevron.down"
        }
    }
}

struct DocumentCheckRow: View {
    let title: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isChecked ? Color.red : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isChecked ? Color.red : Color.gray.opacity(0.5), lineWidth: 2)
                        )
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// CustomDateField больше не нужен, удаляем

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button("Отмена") {
                    isPresented = false
                }
                
                Spacer()
                
                Text("Дата рождения")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Готово") {
                    isPresented = false
                }
                .fontWeight(.semibold)
                .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Date Picker
            DatePicker(
                "Выберите дату рождения",
                selection: $selectedDate,
                in: Calendar.current.date(byAdding: .year, value: -100, to: Date())!...Calendar.current.date(byAdding: .year, value: -16, to: Date())!,
                displayedComponents: .date
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

