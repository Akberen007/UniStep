//
//  RegistrationData.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//
import Foundation
import FirebaseFirestore

// MARK: - Registration Data
struct RegistrationData {
    var email: String = ""
    var password: String = ""
    var role: UserRole = .applicant
    
    // Applicant fields
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    
    // University fields
    var selectedUniversityId: String = ""
    var universityRole: UniversityRole = .admissionOfficer
    
    func toUserModel(universityName: String? = nil) -> UserModel {
        let defaultPermissions: [Permission] = {
            switch universityRole {
            case .admissionOfficer:
                return [.viewApplications, .updateApplicationStatus]
            case .dean:
                return [.viewApplications, .updateApplicationStatus, .viewStatistics]
            case .admin:
                return Permission.allCases
            }
        }()
        
        return UserModel(
            email: email,
            role: role,
            createdAt: Date(),
            isActive: true,
            firstName: role == .applicant ? firstName : nil,
            lastName: role == .applicant ? lastName : nil,
            phoneNumber: role == .applicant ? phoneNumber : nil,
            universityId: role == .university ? selectedUniversityId : nil,
            universityName: universityName,
            universityRole: role == .university ? universityRole : nil,
            permissions: role == .university ? defaultPermissions : nil
        )
    }
}
