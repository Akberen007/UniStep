//
//  UniversityDashboardModels.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import Foundation

// MARK: - Application Status Filter
enum ApplicationStatusFilter: String, CaseIterable {
    case allApps = "all"
    case pendingApps = "pending"
    case acceptedApps = "accepted"
    case rejectedApps = "rejected"
    case awaitingDocsApps = "awaiting_docs"
    
    var displayText: String {
        switch self {
        case .allApps: return "Все"
        case .pendingApps: return "Ожидают"
        case .acceptedApps: return "Приняты"
        case .rejectedApps: return "Отклонены"
        case .awaitingDocsApps: return "Ожидание документов"
        }
    }
}

// MARK: - University Application Data
struct UniversityApplicationData: Identifiable {
    let id: String
    let studentFullName: String
    let studentEmail: String
    let studentPhone: String
    let targetUniversity: String
    let targetFaculty: String
    let targetSpecialty: String
    var currentStatus: String
    let submittedAt: Date
    let studentFirstName: String
    let studentLastName: String
    let studentCity: String
    let studentSchool: String
    let entScore: String?
    let avgGrade: String?
    let studyLanguage: String
    let studyForm: String
    
    // Computed properties для удобства
    var statusEnum: ApplicationStatus {
        return ApplicationStatus(rawValue: currentStatus) ?? .pending
    }
    
    var displaySubmissionDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: submittedAt)
    }
    
    var phoneFormatted: String {
        // Простое форматирование телефона
        let cleaned = studentPhone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if cleaned.count == 11 && cleaned.hasPrefix("7") {
            let prefix = String(cleaned.prefix(1))
            let area = String(cleaned.dropFirst().prefix(3))
            let first = String(cleaned.dropFirst(4).prefix(3))
            let last = String(cleaned.suffix(4))
            return "+\(prefix) (\(area)) \(first)-\(last.prefix(2))-\(last.suffix(2))"
        }
        return studentPhone
    }
}

// MARK: - Faculty Statistics
struct UniversityFacultyStat {
    let facultyName: String
    let totalApps: Int
    let pendingApps: Int
    let acceptedApps: Int
    let rejectedApps: Int
    
    var acceptanceRate: Double {
        guard totalApps > 0 else { return 0 }
        return Double(acceptedApps) / Double(totalApps) * 100
    }
    
    init(facultyName: String, totalApps: Int, pendingApps: Int, acceptedApps: Int, rejectedApps: Int = 0) {
        self.facultyName = facultyName
        self.totalApps = totalApps
        self.pendingApps = pendingApps
        self.acceptedApps = acceptedApps
        self.rejectedApps = rejectedApps
    }
}

// MARK: - Specialty Statistics
struct UniversitySpecialtyStat {
    let specialtyName: String
    let appCount: Int
    let averageEntScore: Double?
    let topApplicantName: String?
    
    init(specialtyName: String, appCount: Int, averageEntScore: Double? = nil, topApplicantName: String? = nil) {
        self.specialtyName = specialtyName
        self.appCount = appCount
        self.averageEntScore = averageEntScore
        self.topApplicantName = topApplicantName
    }
}
