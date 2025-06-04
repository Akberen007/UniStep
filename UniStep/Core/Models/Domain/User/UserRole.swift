
import Foundation
import FirebaseFirestore

// MARK: - User Types
enum UserRole: String, CaseIterable, Codable {
    case applicant = "applicant"
    case university = "university"
    
    var displayName: String {
        switch self {
        case .applicant:
            return "Абитуриент"
        case .university:
            return "Университет"
        }
    }
    
    var description: String {
        switch self {
        case .applicant:
            return "Подача заявок в университеты"
        case .university:
            return "Управление заявками абитуриентов"
        }
    }
    
    var icon: String {
        switch self {
        case .applicant:
            return "person.fill"
        case .university:
            return "building.columns.fill"
        }
    }
}
