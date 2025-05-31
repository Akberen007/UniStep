//
//  University.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import SwiftUI

// MARK: - Data Models
struct University {
    let name: String
    let shortName: String
    let city: String
    let type: UniversityType
    let category: UniversityCategory
    let ranking: Int
    let studentsCount: String
    let topFaculties: [String]
    let description: String
    let website: String
    let phone: String
    let email: String
    let address: String
    let establishedYear: Int
    let faculties: [Faculty]
    let admissionInfo: AdmissionInfo
    
    var color: Color {
        category.color
    }
    
    var icon: String {
        category.icon
    }
}

struct Faculty {
    let name: String
    let specialties: [String]
    let description: String
    let icon: String
}

struct AdmissionInfo {
    let tuitionFee: String
    let entranceExam: String
    let minScore: Int
    let documentsDeadline: String
    let contactPerson: String
    let contactPhone: String
}

enum UniversityType {
    case state, privateType
    
    var displayName: String {
        switch self {
        case .state: return "Государственный"
        case .privateType: return "Частный"
        }
    }
    
    var color: Color {
        switch self {
        case .state: return .blue
        case .privateType: return .purple
        }
    }
}

enum UniversityCategory {
    case it, medical, economic, technical, humanities, pedagogical, legal, agricultural
    
    var displayName: String {
        switch self {
        case .it: return "IT"
        case .medical: return "Медицинский"
        case .economic: return "Экономический"
        case .technical: return "Технический"
        case .humanities: return "Гуманитарный"
        case .pedagogical: return "Педагогический"
        case .legal: return "Юридический"
        case .agricultural: return "Аграрный"
        }
    }
    
    var color: Color {
        switch self {
        case .it: return .blue
        case .medical: return .red
        case .economic: return .green
        case .technical: return .orange
        case .humanities: return .purple
        case .pedagogical: return .teal
        case .legal: return .indigo
        case .agricultural: return .brown
        }
    }
    
    var icon: String {
        switch self {
        case .it: return "laptopcomputer"
        case .medical: return "cross.fill"
        case .economic: return "chart.line.uptrend.xyaxis"
        case .technical: return "gearshape.fill"
        case .humanities: return "book.fill"
        case .pedagogical: return "graduationcap.fill"
        case .legal: return "scale.3d"
        case .agricultural: return "leaf.fill"
        }
    }
}
