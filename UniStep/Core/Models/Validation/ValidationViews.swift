//
//  ValidationViews.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import SwiftUI

// MARK: - Компонент для отображения ошибок валидации
struct ValidationErrorView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 14))
            
            Text(message)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
        )
        .transition(.opacity.combined(with: .slide))
    }
}

// MARK: - Компонент для отображения успеха валидации
struct ValidationSuccessView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 14))
            
            Text(message)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.green)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
        .transition(.opacity.combined(with: .slide))
    }
}

// MARK: - Индикатор валидации для полей
struct ValidationIndicator: View {
    let isValid: Bool
    let hasError: Bool
    
    var body: some View {
        Group {
            if hasError {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            } else if isValid {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                EmptyView()
            }
        }
        .font(.system(size: 16))
        .animation(.easeInOut(duration: 0.2), value: hasError)
        .animation(.easeInOut(duration: 0.2), value: isValid)
    }
}

// MARK: - Обертка для полей с валидацией
struct ValidationFieldWrapper<Content: View>: View {
    let field: FormField
    let validator: ApplicationFormValidator
    let content: Content
    let showSuccessIndicator: Bool
    
    init(
        field: FormField,
        validator: ApplicationFormValidator,
        showSuccessIndicator: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.field = field
        self.validator = validator
        self.showSuccessIndicator = showSuccessIndicator
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
            
            if let error = validator.getError(for: field) {
                ValidationErrorView(message: error)
                    .animation(.easeInOut(duration: 0.3), value: error)
            } else if showSuccessIndicator && !validator.hasError(for: field) {
                ValidationSuccessView(message: "✓ Корректно заполнено")
                    .animation(.easeInOut(duration: 0.3), value: validator.hasError(for: field))
            }
        }
    }
}

// MARK: - Сводка ошибок валидации
struct ValidationSummaryView: View {
    @ObservedObject var validator: ApplicationFormValidator
    let title: String
    
    init(validator: ApplicationFormValidator, title: String = "Исправьте следующие ошибки:") {
        self.validator = validator
        self.title = title
    }
    
    var body: some View {
        if !validator.errors.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(validator.errors.keys), id: \.self) { field in
                        if let error = validator.errors[field] {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.red)
                                    .font(.system(size: 14, weight: .bold))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(field.displayName)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(error)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
            .transition(.opacity.combined(with: .slide))
        }
    }
}

// MARK: - Индикатор прогресса валидации
struct ValidationProgressView: View {
    @ObservedObject var validator: ApplicationFormValidator
    let totalFields: Int
    
    private var validFields: Int {
        return totalFields - validator.errors.count
    }
    
    private var progress: Double {
        return totalFields > 0 ? Double(validFields) / Double(totalFields) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Прогресс заполнения")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(validFields)/\(totalFields)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: progress == 1.0 ? .green : .blue))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Кнопка с валидацией
struct ValidatedButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    let isLoading: Bool
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .blue
            case .secondary: return .gray
            case .destructive: return .red
            }
        }
        
        var foregroundColor: Color {
            return .white
        }
    }
    
    init(
        title: String,
        action: @escaping () -> Void,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        style: ButtonStyle = .primary
    ) {
        self.title = title
        self.action = action
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.style = style
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isEnabled ?
                        LinearGradient(
                            colors: [style.backgroundColor, style.backgroundColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [Color.gray.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .foregroundColor(isEnabled ? style.foregroundColor : .gray)
            .shadow(
                color: isEnabled ? style.backgroundColor.opacity(0.3) : .clear,
                radius: 8, x: 0, y: 4
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}
