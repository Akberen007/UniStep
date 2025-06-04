//
//  ValidationModels.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import Foundation

// MARK: - Модель ошибки валидации
struct ValidationError {
    let field: String
    let message: String
}

// MARK: - Enum для полей формы
enum FormField: String, CaseIterable {
    case firstName = "firstName"
    case lastName = "lastName"
    case middleName = "middleName"
    case birthDate = "birthDate"
    case phoneNumber = "phoneNumber"
    case email = "email"
    case entScore = "entScore"
    case certificateScore = "certificateScore"
    case university = "university"
    case faculty = "faculty"
    case specialty = "specialty"
    case customSpecialty = "customSpecialty"
    case documents = "documents"
    
    var displayName: String {
        switch self {
        case .firstName: return "Имя"
        case .lastName: return "Фамилия"
        case .middleName: return "Отчество"
        case .birthDate: return "Дата рождения"
        case .phoneNumber: return "Номер телефона"
        case .email: return "Email"
        case .entScore: return "Балл ЕНТ/КТА"
        case .certificateScore: return "Средний балл аттестата"
        case .university: return "Университет"
        case .faculty: return "Факультет"
        case .specialty: return "Специальность"
        case .customSpecialty: return "Другая специальность"
        case .documents: return "Документы"
        }
    }
    
    var isRequired: Bool {
        switch self {
        case .middleName: return false
        default: return true
        }
    }
}

// MARK: - Типы валидации
enum ValidationType {
    case required
    case minLength(Int)
    case maxLength(Int)
    case email
    case phone
    case name
    case score(min: Double, max: Double)
    case age(min: Int, max: Int)
    case documents(required: [String])
    
    var errorMessage: String {
        switch self {
        case .required:
            return "Поле обязательно для заполнения"
        case .minLength(let count):
            return "Минимум \(count) символов"
        case .maxLength(let count):
            return "Максимум \(count) символов"
        case .email:
            return "Неверный формат email адреса"
        case .phone:
            return "Неверный формат номера телефона"
        case .name:
            return "Должно содержать только буквы"
        case .score(let min, let max):
            return "Значение должно быть от \(min) до \(max)"
        case .age(let min, let max):
            return "Возраст должен быть от \(min) до \(max) лет"
        case .documents:
            return "Загрузите все обязательные документы"
        }
    }
}

// MARK: - Правила валидации для полей
struct FieldValidationRules {
    static let rules: [FormField: [ValidationType]] = [
        .firstName: [.required, .minLength(2), .name],
        .lastName: [.required, .minLength(2), .name],
        .middleName: [.minLength(2), .name],
        .phoneNumber: [.required, .phone],
        .email: [.required, .email],
        .entScore: [.required, .score(min: 0, max: 140)],
        .certificateScore: [.required, .score(min: 2.0, max: 5.0)],
        .university: [.required],
        .faculty: [.required],
        .specialty: [.required],
        .customSpecialty: [.required, .minLength(3)],
        .documents: [.documents(required: ["Копия удостоверения личности", "Документ об образовании", "Результаты ЕНТ/КТА"])]
    ]
}
