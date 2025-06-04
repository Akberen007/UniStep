//
//  ValidatedTextField.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import SwiftUI

// MARK: - Текстовое поле с валидацией
struct ValidatedTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let field: FormField
    @ObservedObject var validator: ApplicationFormValidator
    let keyboardType: UIKeyboardType
    let autocapitalizationType: TextInputAutocapitalization
    let isSecure: Bool
    let showValidationIndicator: Bool
    let maxLength: Int?
    
    @FocusState private var isFocused: Bool
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        field: FormField,
        validator: ApplicationFormValidator,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: TextInputAutocapitalization = .words,
        isSecure: Bool = false,
        showValidationIndicator: Bool = true,
        maxLength: Int? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.field = field
        self.validator = validator
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.isSecure = isSecure
        self.showValidationIndicator = showValidationIndicator
        self.maxLength = maxLength
    }
    
    var body: some View {
        ValidationFieldWrapper(field: field, validator: validator) {
            VStack(alignment: .leading, spacing: 8) {
                // Заголовок поля
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if field.isRequired {
                        Text("*")
                            .foregroundColor(.red)
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                    Spacer()
                    
                    // Индикатор валидации
                    if showValidationIndicator {
                        ValidationIndicator(
                            isValid: !text.isEmpty && !validator.hasError(for: field),
                            hasError: validator.hasError(for: field)
                        )
                    }
                }
                
                // Текстовое поле
                HStack {
                    Group {
                        if isSecure {
                            SecureField(placeholder, text: $text)
                        } else {
                            TextField(placeholder, text: $text)
                        }
                    }
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalizationType)
                    .focused($isFocused)
                    .onChange(of: text) { newValue in
                        // Ограничение длины
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                        
                        // Валидация в реальном времени
                        validator.validateFieldRealTime(field, value: text)
                    }
                    .onSubmit {
                        validator.validateField(field, value: text)
                    }
                    
                    // Кнопка очистки
                    if !text.isEmpty && isFocused {
                        Button(action: {
                            text = ""
                            validator.clearError(for: field)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    validator.hasError(for: field) ? Color.red :
                                    isFocused ? Color.blue :
                                    Color.clear,
                                    lineWidth: validator.hasError(for: field) ? 2 : 1
                                )
                        )
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: validator.hasError(for: field))
                
                // Счетчик символов (если установлен maxLength)
                if let maxLength = maxLength {
                    HStack {
                        Spacer()
                        Text("\(text.count)/\(maxLength)")
                            .font(.system(size: 12))
                            .foregroundColor(
                                text.count > maxLength ? .red :
                                text.count > Int(Double(maxLength) * 0.8) ? .orange :
                                .secondary
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Специализированные текстовые поля

// Поле для ввода имени
struct NameTextField: View {
    let title: String
    @Binding var text: String
    let field: FormField
    @ObservedObject var validator: ApplicationFormValidator
    
    var body: some View {
        ValidatedTextField(
            title: title,
            placeholder: "Введите \(title.lowercased())",
            text: $text,
            field: field,
            validator: validator,
            keyboardType: .default,
            autocapitalizationType: .words,
            maxLength: 50
        )
    }
}

// Поле для ввода email
struct EmailTextField: View {
    @Binding var text: String
    @ObservedObject var validator: ApplicationFormValidator
    
    var body: some View {
        ValidatedTextField(
            title: "Email адрес",
            placeholder: "example@mail.com",
            text: $text,
            field: .email,
            validator: validator,
            keyboardType: .emailAddress,
            autocapitalizationType: .never,
            maxLength: 100
        )
    }
}

// Поле для ввода телефона
struct PhoneTextField: View {
    @Binding var text: String
    @ObservedObject var validator: ApplicationFormValidator
    
    var body: some View {
        ValidatedTextField(
            title: "Номер телефона",
            placeholder: "+7 (777) 123-45-67",
            text: $text,
            field: .phoneNumber,
            validator: validator,
            keyboardType: .phonePad,
            autocapitalizationType: .never,
            maxLength: 18
        )
    }
}

// Поле для ввода баллов
struct ScoreTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let field: FormField
    @ObservedObject var validator: ApplicationFormValidator
    let range: ClosedRange<Double>
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        field: FormField,
        validator: ApplicationFormValidator,
        range: ClosedRange<Double>
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.field = field
        self.validator = validator
        self.range = range
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ValidatedTextField(
                title: title,
                placeholder: placeholder,
                text: $text,
                field: field,
                validator: validator,
                keyboardType: .decimalPad,
                autocapitalizationType: .never
            )
            
            // Подсказка с диапазоном
            Text("Диапазон: \(String(format: "%.1f", range.lowerBound)) - \(String(format: "%.1f", range.upperBound))")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
        }
    }
}

// MARK: - Вспомогательные view модификаторы

extension View {
    func validationFieldStyle() -> some View {
        self
            .textFieldStyle(PlainTextFieldStyle())
            .font(.system(size: 16))
            .foregroundColor(.primary)
    }
}

// MARK: - Preview Provider
struct ValidatedTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ValidatedTextField(
                title: "Имя",
                placeholder: "Введите ваше имя",
                text: .constant(""),
                field: .firstName,
                validator: ApplicationFormValidator()
            )
            
            EmailTextField(
                text: .constant(""),
                validator: ApplicationFormValidator()
            )
            
            PhoneTextField(
                text: .constant(""),
                validator: ApplicationFormValidator()
            )
            
            ScoreTextField(
                title: "Балл ЕНТ",
                placeholder: "Введите балл ЕНТ",
                text: .constant(""),
                field: .entScore,
                validator: ApplicationFormValidator(),
                range: 0...140
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
