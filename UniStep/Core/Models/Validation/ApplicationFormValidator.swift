//
//  ApplicationFormValidator.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import Foundation
import SwiftUI

// MARK: - Основной класс валидации
class ApplicationFormValidator: ObservableObject {
    @Published var errors: [FormField: String] = [:]
    @Published var isValid: Bool = false
    
    // MARK: - Основная функция валидации формы
    func validateForm(
        firstName: String,
        lastName: String,
        middleName: String,
        birthDate: Date,
        phoneNumber: String,
        email: String,
        entScore: String,
        certificateScore: String,
        selectedUniversity: String,
        selectedFaculty: String,
        selectedSpecialty: String,
        customSpecialty: String,
        uploadedDocuments: [String],
        currentStep: Int
    ) -> Bool {
        
        errors.removeAll()
        
        // Валидация по шагам
        switch currentStep {
        case 0: // Шаг 1: Персональная информация
            validatePersonalInfo(
                firstName: firstName,
                lastName: lastName,
                middleName: middleName,
                birthDate: birthDate
            )
            
        case 1: // Шаг 2: Контактные данные
            validateContactInfo(
                phoneNumber: phoneNumber,
                email: email
            )
            
        case 2: // Шаг 3: Академическая информация
            validateAcademicInfo(
                entScore: entScore,
                certificateScore: certificateScore
            )
            
        case 3: // Шаг 4: Выбор университета
            validateUniversitySelection(
                university: selectedUniversity,
                faculty: selectedFaculty,
                specialty: selectedSpecialty,
                customSpecialty: customSpecialty
            )
            
        case 4: // Шаг 5: Документы
            validateDocuments(documents: uploadedDocuments)
            
        default:
            break
        }
        
        isValid = errors.isEmpty
        return isValid
    }
    
    // MARK: - Валидация персональной информации
    private func validatePersonalInfo(firstName: String, lastName: String, middleName: String, birthDate: Date) {
        validateField(.firstName, value: firstName)
        validateField(.lastName, value: lastName)
        
        // Отчество опционально
        if !middleName.trimmingCharacters(in: .whitespaces).isEmpty {
            validateField(.middleName, value: middleName)
        }
        
        validateBirthDate(birthDate)
    }
    
    // MARK: - Валидация контактной информации
    private func validateContactInfo(phoneNumber: String, email: String) {
        validateField(.phoneNumber, value: phoneNumber)
        validateField(.email, value: email)
    }
    
    // MARK: - Валидация академической информации
    private func validateAcademicInfo(entScore: String, certificateScore: String) {
        validateField(.entScore, value: entScore)
        validateField(.certificateScore, value: certificateScore)
    }
    
    // MARK: - Валидация выбора университета
    private func validateUniversitySelection(university: String, faculty: String, specialty: String, customSpecialty: String) {
        validateField(.university, value: university)
        validateField(.faculty, value: faculty)
        validateField(.specialty, value: specialty)
        
        // Если выбрано "Другое..." - валидируем custom поле
        if specialty == "Другое..." {
            validateField(.customSpecialty, value: customSpecialty)
        }
    }
    
    // MARK: - Валидация документов
    private func validateDocuments(documents: [String]) {
        let requiredDocuments = [
            "Копия удостоверения личности",
            "Документ об образовании",
            "Результаты ЕНТ/КТА"
        ]
        
        for doc in requiredDocuments {
            if !documents.contains(doc) {
                errors[.documents] = "Загрузите все обязательные документы"
                return
            }
        }
        
        if documents.isEmpty {
            errors[.documents] = "Загрузите хотя бы один документ"
        }
    }
    
    // MARK: - Валидация конкретного поля
    func validateField(_ field: FormField, value: String) {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        // Получаем правила для поля
        guard let rules = FieldValidationRules.rules[field] else {
            return
        }
        
        // Проверяем каждое правило
        for rule in rules {
            if let error = validateRule(rule, value: trimmedValue, field: field) {
                errors[field] = error
                return
            }
        }
        
        // Если ошибок нет - удаляем поле из ошибок
        errors.removeValue(forKey: field)
        updateValidationState()
    }
    
    // MARK: - Валидация даты рождения
    private func validateBirthDate(_ birthDate: Date) {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year ?? 0
        
        if age < 15 {
            errors[.birthDate] = "Возраст должен быть не менее 15 лет"
        } else if age > 65 {
            errors[.birthDate] = "Возраст должен быть не более 65 лет"
        } else {
            errors.removeValue(forKey: .birthDate)
        }
        
        updateValidationState()
    }
    
    // MARK: - Валидация правила
    private func validateRule(_ rule: ValidationType, value: String, field: FormField) -> String? {
        switch rule {
        case .required:
            return value.isEmpty ? "Поле \"\(field.displayName)\" обязательно для заполнения" : nil
            
        case .minLength(let count):
            return value.count < count ? "Минимум \(count) символов" : nil
            
        case .maxLength(let count):
            return value.count > count ? "Максимум \(count) символов" : nil
            
        case .email:
            return !isValidEmail(value) ? "Неверный формат email адреса" : nil
            
        case .phone:
            return !isValidPhoneNumber(value) ? "Неверный формат номера телефона" : nil
            
        case .name:
            return !isValidName(value) ? "Должно содержать только буквы" : nil
            
        case .score(let min, let max):
            if let score = Double(value) {
                return (score < min || score > max) ? "Значение должно быть от \(min) до \(max)" : nil
            } else {
                return "Введите корректное числовое значение"
            }
            
        case .age, .documents:
            return nil // Эти правила обрабатываются отдельно
        }
    }
    
    // MARK: - Вспомогательные функции валидации
    
    private func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[а-яёА-ЯЁa-zA-Z\\s-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        // Удаляем все символы кроме цифр и +
        let cleanPhone = phone.components(separatedBy: CharacterSet(charactersIn: "0123456789+").inverted).joined()
        
        // Проверяем различные форматы казахстанских номеров
        let phoneRegexes = [
            "^\\+?7[0-9]{10}$",      // +77771234567 или 77771234567
            "^8[0-9]{10}$",          // 87771234567
            "^[0-9]{10}$"            // 7771234567
        ]
        
        for regex in phoneRegexes {
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if phonePredicate.evaluate(with: cleanPhone) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Утилиты для работы с ошибками
    
    func getError(for field: FormField) -> String? {
        return errors[field]
    }
    
    func hasError(for field: FormField) -> Bool {
        return errors[field] != nil
    }
    
    func clearError(for field: FormField) {
        errors.removeValue(forKey: field)
        updateValidationState()
    }
    
    func clearAllErrors() {
        errors.removeAll()
        updateValidationState()
    }
    
    private func updateValidationState() {
        isValid = errors.isEmpty
    }
    
    // MARK: - Валидация в реальном времени
    func validateFieldRealTime(_ field: FormField, value: String) {
        // Не показываем ошибки для пустых необязательных полей
        if value.isEmpty && !field.isRequired {
            errors.removeValue(forKey: field)
            updateValidationState()
            return
        }
        
        validateField(field, value: value)
    }
    
    // MARK: - Получение всех ошибок
    func getAllErrors() -> [String] {
        return Array(errors.values)
    }
    
    // MARK: - Проверка готовности шага
    func isStepValid(_ step: Int) -> Bool {
        let stepFields: [Int: [FormField]] = [
            0: [.firstName, .lastName, .birthDate],
            1: [.phoneNumber, .email],
            2: [.entScore, .certificateScore],
            3: [.university, .faculty, .specialty],
            4: [.documents]
        ]
        
        guard let fieldsToCheck = stepFields[step] else { return true }
        
        for field in fieldsToCheck {
            if hasError(for: field) {
                return false
            }
        }
        
        return true
    }
}
