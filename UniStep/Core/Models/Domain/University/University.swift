//
//  University.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
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
    let logoImage: String? // Новое поле для логотипа (опциональное)
    
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

// MARK: - Calculator Data Models

struct SpecialtyInfo {
    let name: String
    let minGrantScore: Int  // Минимальный балл для гранта
    let minPaidScore: Int   // Минимальный балл для платного
}

struct FacultyInfo {
    let name: String
    let specialties: [SpecialtyInfo]
}

struct UniversityCalculatorInfo {
    let name: String
    let faculties: [FacultyInfo]
    let prestigeLevel: Double // Коэффициент престижности (0.6-0.9)
}

// MARK: - Calculator Database Extension

extension University {
    
    /// Статические данные для калькулятора шансов поступления
    static let calculatorData: [UniversityCalculatorInfo] = [
        // КАЗНУ им. аль-Фараби
        UniversityCalculatorInfo(
            name: "КазНУ",
            faculties: [
                FacultyInfo(
                    name: "Информационных технологий",
                    specialties: [
                        SpecialtyInfo(name: "Информационные системы", minGrantScore: 90, minPaidScore: 75),
                        SpecialtyInfo(name: "Программная инженерия", minGrantScore: 92, minPaidScore: 77),
                        SpecialtyInfo(name: "Информационная безопасность", minGrantScore: 85, minPaidScore: 70)
                    ]
                ),
                FacultyInfo(
                    name: "Экономики и бизнеса",
                    specialties: [
                        SpecialtyInfo(name: "Экономика", minGrantScore: 88, minPaidScore: 73),
                        SpecialtyInfo(name: "Менеджмент", minGrantScore: 70, minPaidScore: 55),
                        SpecialtyInfo(name: "Маркетинг", minGrantScore: 70, minPaidScore: 55)
                    ]
                ),
                FacultyInfo(
                    name: "Юридический",
                    specialties: [
                        SpecialtyInfo(name: "Юриспруденция", minGrantScore: 114, minPaidScore: 99)
                    ]
                )
            ],
            prestigeLevel: 0.7
        ),
        
        // КазНМУ им. С.Д. Асфендиярова
        UniversityCalculatorInfo(
            name: "КазНМУ",
            faculties: [
                FacultyInfo(
                    name: "Общей медицины",
                    specialties: [
                        SpecialtyInfo(name: "Медицина", minGrantScore: 124, minPaidScore: 109),
                        SpecialtyInfo(name: "Педиатрия", minGrantScore: 111, minPaidScore: 96)
                    ]
                ),
                FacultyInfo(
                    name: "Стоматологический",
                    specialties: [
                        SpecialtyInfo(name: "Стоматология", minGrantScore: 136, minPaidScore: 121)
                    ]
                ),
                FacultyInfo(
                    name: "Общественного здравоохранения",
                    specialties: [
                        SpecialtyInfo(name: "Общественное здравоохранение", minGrantScore: 125, minPaidScore: 110),
                        SpecialtyInfo(name: "Фармация", minGrantScore: 124, minPaidScore: 109)
                    ]
                )
            ],
            prestigeLevel: 0.65
        ),
        
        // КазНПУ им. Абая
        UniversityCalculatorInfo(
            name: "КазНПУ",
            faculties: [
                FacultyInfo(
                    name: "Педагогический",
                    specialties: [
                        SpecialtyInfo(name: "Педагогика", minGrantScore: 75, minPaidScore: 60),
                        SpecialtyInfo(name: "Дошкольное обучение и воспитание", minGrantScore: 75, minPaidScore: 60),
                        SpecialtyInfo(name: "Начальное образование", minGrantScore: 75, minPaidScore: 60)
                    ]
                ),
                FacultyInfo(
                    name: "Гуманитарный",
                    specialties: [
                        SpecialtyInfo(name: "Филология", minGrantScore: 75, minPaidScore: 60),
                        SpecialtyInfo(name: "Социальная педагогика", minGrantScore: 75, minPaidScore: 60)
                    ]
                )
            ],
            prestigeLevel: 0.85
        ),
        
        // МУИТ
        UniversityCalculatorInfo(
            name: "МУИТ",
            faculties: [
                FacultyInfo(
                    name: "Информационных технологий",
                    specialties: [
                        SpecialtyInfo(name: "Информационные системы", minGrantScore: 80, minPaidScore: 65),
                        SpecialtyInfo(name: "Программная инженерия", minGrantScore: 82, minPaidScore: 67),
                        SpecialtyInfo(name: "Информационная безопасность", minGrantScore: 78, minPaidScore: 63)
                    ]
                ),
                FacultyInfo(
                    name: "Экономики и бизнеса",
                    specialties: [
                        SpecialtyInfo(name: "Экономика", minGrantScore: 75, minPaidScore: 60),
                        SpecialtyInfo(name: "Менеджмент", minGrantScore: 72, minPaidScore: 57)
                    ]
                )
            ],
            prestigeLevel: 0.78
        ),
        
        // КИМЭП
        UniversityCalculatorInfo(
            name: "КИМЭП",
            faculties: [
                FacultyInfo(
                    name: "Бизнеса",
                    specialties: [
                        SpecialtyInfo(name: "Экономика", minGrantScore: 110, minPaidScore: 95),
                        SpecialtyInfo(name: "Менеджмент", minGrantScore: 105, minPaidScore: 90),
                        SpecialtyInfo(name: "Маркетинг", minGrantScore: 100, minPaidScore: 85)
                    ]
                )
            ],
            prestigeLevel: 0.65
        ),
        
        // НУ (Назарбаев Университет)
        UniversityCalculatorInfo(
            name: "НУ",
            faculties: [
                FacultyInfo(
                    name: "Инженерии и цифровых технологий",
                    specialties: [
                        SpecialtyInfo(name: "Информационные системы", minGrantScore: 125, minPaidScore: 110),
                        SpecialtyInfo(name: "Программная инженерия", minGrantScore: 128, minPaidScore: 113)
                    ]
                ),
                FacultyInfo(
                    name: "Бизнес-школа",
                    specialties: [
                        SpecialtyInfo(name: "Экономика", minGrantScore: 120, minPaidScore: 105),
                        SpecialtyInfo(name: "Менеджмент", minGrantScore: 118, minPaidScore: 103)
                    ]
                )
            ],
            prestigeLevel: 0.6
        ),
        
        // КазНТУ
        UniversityCalculatorInfo(
            name: "КазНТУ",
            faculties: [
                FacultyInfo(
                    name: "Информационных технологий",
                    specialties: [
                        SpecialtyInfo(name: "Информационные системы", minGrantScore: 85, minPaidScore: 70),
                        SpecialtyInfo(name: "Программная инженерия", minGrantScore: 87, minPaidScore: 72)
                    ]
                ),
                FacultyInfo(
                    name: "Инженерный",
                    specialties: [
                        SpecialtyInfo(name: "Инженерия", minGrantScore: 82, minPaidScore: 67)
                    ]
                )
            ],
            prestigeLevel: 0.8
        ),
        
        // КБТУ
        UniversityCalculatorInfo(
            name: "КБТУ",
            faculties: [
                FacultyInfo(
                    name: "Информационных технологий",
                    specialties: [
                        SpecialtyInfo(name: "Информационные системы", minGrantScore: 88, minPaidScore: 73),
                        SpecialtyInfo(name: "Программная инженерия", minGrantScore: 90, minPaidScore: 75)
                    ]
                )
            ],
            prestigeLevel: 0.75
        ),
        
        // КазГЮУ
        UniversityCalculatorInfo(
            name: "КазГЮУ",
            faculties: [
                FacultyInfo(
                    name: "Юридический",
                    specialties: [
                        SpecialtyInfo(name: "Юриспруденция", minGrantScore: 95, minPaidScore: 80)
                    ]
                )
            ],
            prestigeLevel: 0.8
        )
    ]
    
    // MARK: - Calculator Helper Methods
    
    /// Найти данные университета для калькулятора по названию
    static func getCalculatorUniversity(by name: String) -> UniversityCalculatorInfo? {
        return calculatorData.first { $0.name == name }
    }
    
    /// Найти специальность в конкретном университете
    static func getSpecialty(university: String, specialty: String) -> SpecialtyInfo? {
        guard let uni = getCalculatorUniversity(by: university) else { return nil }
        
        for faculty in uni.faculties {
            if let found = faculty.specialties.first(where: { $0.name == specialty }) {
                return found
            }
        }
        return nil
    }
    
    /// Получить все названия специальностей (уникальные)
    static func getAllSpecialtyNames() -> [String] {
        var specialties: Set<String> = []
        for university in calculatorData {
            for faculty in university.faculties {
                for specialty in faculty.specialties {
                    specialties.insert(specialty.name)
                }
            }
        }
        return Array(specialties).sorted()
    }
    
    /// Получить все названия университетов для калькулятора
    static func getCalculatorUniversityNames() -> [String] {
        return calculatorData.map { $0.name }.sorted()
    }
    
    /// Маппинг между краткими и полными названиями
    static let universityNameMapping: [String: String] = [
        "КазНУ": "КазНУ им. аль-Фараби",
        "КазНМУ": "КазНМУ им. С.Д. Асфендиярова",
        "КазНПУ": "КазНПУ им. Абая",
        "МУИТ": "Международный университет информационных технологий",
        "КИМЭП": "КИМЭП",
        "НУ": "Назарбаев Университет",
        "КазНТУ": "КазНТУ им. К.И. Сатпаева",
        "КБТУ": "Казахстанско-Британский технический университет",
        "КазГЮУ": "Казахский гуманитарно-юридический университет"
    ]
}
