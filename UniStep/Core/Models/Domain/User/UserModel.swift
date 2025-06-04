
//
//  UserModel.swift
//  UniStep
//
//  Created by Akberen on 28.05.2025.
//


import Foundation
import FirebaseFirestore

// MARK: - Main User Model (обновляем ваш существующий)
struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String { id ?? "" }
    let email: String
    let role: UserRole
    let createdAt: Date
    let isActive: Bool
    
    // Applicant specific fields
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    
    // University specific fields
    let universityId: String?
    let universityName: String?
    let universityRole: UniversityRole?
    let permissions: [Permission]?
    
    var displayName: String {
        if role == .applicant {
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            return email
        } else {
            return universityName ?? email
        }
    }
    
    // Инициализатор для совместимости с вашим старым кодом
    init(uid: String, email: String, role: String) {
        self.id = uid
        self.email = email
        self.role = UserRole(rawValue: role) ?? .applicant
        self.createdAt = Date()
        self.isActive = true
        self.firstName = nil
        self.lastName = nil
        self.phoneNumber = nil
        self.universityId = nil
        self.universityName = nil
        self.universityRole = nil
        self.permissions = nil
    }
    
    // Полный инициализатор
    init(
        id: String? = nil,
        email: String,
        role: UserRole,
        createdAt: Date = Date(),
        isActive: Bool = true,
        firstName: String? = nil,
        lastName: String? = nil,
        phoneNumber: String? = nil,
        universityId: String? = nil,
        universityName: String? = nil,
        universityRole: UniversityRole? = nil,
        permissions: [Permission]? = nil
    ) {
        self.id = id
        self.email = email
        self.role = role
        self.createdAt = createdAt
        self.isActive = isActive
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.universityId = universityId
        self.universityName = universityName
        self.universityRole = universityRole
        self.permissions = permissions
    }
}

// MARK: - University Roles
enum UniversityRole: String, CaseIterable, Codable {
    case admissionOfficer = "admission_officer"
    case dean = "dean"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .admissionOfficer:
            return "Сотрудник приемной комиссии"
        case .dean:
            return "Декан"
        case .admin:
            return "Администратор университета"
        }
    }
}

// MARK: - Permissions
enum Permission: String, CaseIterable, Codable {
    case viewApplications = "view_applications"
    case updateApplicationStatus = "update_application_status"
    case deleteApplications = "delete_applications"
    case manageUsers = "manage_users"
    case viewStatistics = "view_statistics"
    
    var displayName: String {
        switch self {
        case .viewApplications:
            return "Просмотр заявок"
        case .updateApplicationStatus:
            return "Изменение статуса заявок"
        case .deleteApplications:
            return "Удаление заявок"
        case .manageUsers:
            return "Управление пользователями"
        case .viewStatistics:
            return "Просмотр статистики"
        }
    }
}
