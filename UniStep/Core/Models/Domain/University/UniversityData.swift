//
//  UniversityData.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import Foundation
import FirebaseFirestore

// MARK: - Sample Data
let universitiesData: [University] = [
    University(
        name: "Международный университет информационных технологий",
        shortName: "МУИТ",
        city: "Алматы",
        type: .privateType,
        category: .it,
        ranking: 1,
        studentsCount: "8,500",
        topFaculties: ["Информационные технологии", "Компьютерные науки", "Цифровые технологии"],
        description: "Ведущий IT-университет Казахстана, специализирующийся на современных информационных технологиях.",
        website: "https://iitu.edu.kz",
        phone: "+7 (727) 330-00-00",
        email: "info@iitu.edu.kz",
        address: "г. Алматы, ул. Манаса, 34/1",
        establishedYear: 2009,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "1,200,000 ₸/год",
            entranceExam: "ЕНТ/КТА",
            minScore: 115,
            documentsDeadline: "25 июля",
            contactPerson: "Айнур Касымова",
            contactPhone: "+7 (727) 330-00-01"
        ),
        logoImage: "IITU" // Логотип МУИТ
    ),
    
    University(
        name: "Казахский национальный университет имени аль-Фараби",
        shortName: "КазНУ",
        city: "Алматы",
        type: .state,
        category: .humanities,
        ranking: 2,
        studentsCount: "35,000",
        topFaculties: ["Филологический", "Международных отношений", "Экономический"],
        description: "Главный университет Казахстана, ведущий научно-образовательный центр страны.",
        website: "https://kaznu.kz",
        phone: "+7 (727) 377-33-30",
        email: "info@kaznu.kz",
        address: "г. Алматы, пр. аль-Фараби, 71",
        establishedYear: 1934,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "500,000 ₸/год",
            entranceExam: "ЕНТ",
            minScore: 125,
            documentsDeadline: "20 июля",
            contactPerson: "Марат Ибрагимов",
            contactPhone: "+7 (727) 377-33-31"
        ),
        logoImage: "KAZGU"
    ),
    
    University(
        name: "Казахский национальный технический университет имени К.И. Сатпаева",
        shortName: "КазНТУ",
        city: "Алматы",
        type: .state,
        category: .technical,
        ranking: 3,
        studentsCount: "28,000",
        topFaculties: ["Горно-металлургический", "Энергетический", "Инженерный"],
        description: "Ведущий технический университет, готовящий инженерные кадры для промышленности.",
        website: "https://satbayev.university",
        phone: "+7 (727) 292-25-20",
        email: "info@satbayev.university",
        address: "г. Алматы, ул. Сатпаева, 22а",
        establishedYear: 1934,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "450,000 ₸/год",
            entranceExam: "ЕНТ",
            minScore: 110,
            documentsDeadline: "22 июля",
            contactPerson: "Дамир Нуржанов",
            contactPhone: "+7 (727) 292-25-21"
        ),
        logoImage: "KAZNTU" // Нет логотипа
    ),
    
    University(
        name: "Казахстанско-Британский технический университет",
        shortName: "КБТУ",
        city: "Алматы",
        type: .privateType,
        category: .technical,
        ranking: 4,
        studentsCount: "4,200",
        topFaculties: ["Нефтегазовая инженерия", "Информационные технологии", "Бизнес"],
        description: "Престижный частный университет с британскими образовательными стандартами.",
        website: "https://kbtu.kz",
        phone: "+7 (727) 320-30-50",
        email: "info@kbtu.kz",
        address: "г. Алматы, ул. Толе би, 59",
        establishedYear: 2001,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "2,500,000 ₸/год",
            entranceExam: "Внутренний экзамен",
            minScore: 120,
            documentsDeadline: "30 июня",
            contactPerson: "Асем Болатова",
            contactPhone: "+7 (727) 320-30-51"
        ),
        logoImage: "KBTU" // Нет логотипа
    ),
    
    University(
        name: "Казахский национальный медицинский университет имени С.Д. Асфендиярова",
        shortName: "КазНМУ",
        city: "Алматы",
        type: .state,
        category: .medical,
        ranking: 5,
        studentsCount: "12,000",
        topFaculties: ["Медицинский", "Стоматологический", "Фармацевтический"],
        description: "Ведущий медицинский университет, готовящий врачей и медицинских специалистов.",
        website: "https://kaznmu.kz",
        phone: "+7 (727) 292-57-12",
        email: "info@kaznmu.kz",
        address: "г. Алматы, ул. Толе би, 94",
        establishedYear: 1931,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "800,000 ₸/год",
            entranceExam: "ЕНТ + профильный экзамен",
            minScore: 135,
            documentsDeadline: "15 июля",
            contactPerson: "Гульнара Смагулова",
            contactPhone: "+7 (727) 292-57-13"
        ),
        logoImage: "KAZNMU" // Нет логотипа
    ),
    
    University(
        name: "КИМЭП",
        shortName: "КИМЭП",
        city: "Алматы",
        type: .privateType,
        category: .economic,
        ranking: 6,
        studentsCount: "3,800",
        topFaculties: ["Бизнес-школа", "Юридическая школа", "Государственная политика"],
        description: "Престижный частный университет, специализирующийся на экономике и бизнесе.",
        website: "https://kimep.kz",
        phone: "+7 (727) 270-40-00",
        email: "info@kimep.kz",
        address: "г. Алматы, ул. Абая, 2",
        establishedYear: 1992,
        faculties: [],
        admissionInfo: AdmissionInfo(
            tuitionFee: "2,800,000 ₸/год",
            entranceExam: "КIMEP Admission Test",
            minScore: 115,
            documentsDeadline: "1 июля",
            contactPerson: "Айжан Турысбекова",
            contactPhone: "+7 (727) 270-40-01"
        ),
        logoImage: "KIMEP" // Нет логотипа
    )
]

// MARK: - Test Data Creator
class TestDataCreator {
    static let shared = TestDataCreator()
    private let db = Firestore.firestore()
    
    func createTestApplicationsIfNeeded() {
        db.collection("applications").limit(to: 1).getDocuments { snapshot, error in
            if let documents = snapshot?.documents, documents.isEmpty {
                print("🔧 Создаем тестовые заявки...")
                self.createTestApplications()
            } else {
                print("✅ Заявки уже существуют")
            }
        }
    }
    
    private func createTestApplications() {
        let testApplications: [[String: Any]] = [
            [
                "id": "AB2025-1001",
                "fullName": "Алиев Нурлан Асылбекович",
                "university": "МУИТ",
                "faculty": "Информационные технологии",
                "specialty": "Программная инженерия",
                "phone": "+77771234567",
                "email": "nurlan.aliev@example.kz",
                "status": "pending",
                "submissionDate": Timestamp()
            ],
            [
                "id": "AB2025-1002",
                "fullName": "Сагындыкова Айгерим Болатовна",
                "university": "КазНУ",
                "faculty": "Филологический",
                "specialty": "Казахская филология",
                "phone": "87012345678",
                "email": "aigerim.sagyndykova@example.kz",
                "status": "accepted",
                "submissionDate": Timestamp()
            ]
        ]
        
        for applicationData in testApplications {
            db.collection("applications").addDocument(data: applicationData) { error in
                if let error = error {
                    print("❌ Ошибка: \(error)")
                } else {
                    print("✅ Создана заявка для \(applicationData["fullName"] ?? "")")
                }
            }
        }
    }
}
