//
//  UniversityDataManager.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class UniversityAppDataManager: ObservableObject {
    @Published var universityApps: [UniversityApplicationData] = []
    @Published var isLoadingData = false
    @Published var errorMessage: String?
    var currentUniversityName: String?
    
    private let firestore = Firestore.firestore()
    
    var facultyStats: [UniversityFacultyStat] {
        let grouped = Dictionary(grouping: universityApps) { $0.targetFaculty }
        return grouped.map { faculty, apps in
            UniversityFacultyStat(
                facultyName: faculty,
                totalApps: apps.count,
                pendingApps: apps.filter { $0.currentStatus == "pending" }.count,
                acceptedApps: apps.filter { $0.currentStatus == "accepted" }.count,
                rejectedApps: apps.filter { $0.currentStatus == "rejected" }.count
            )
        }.sorted { $0.totalApps > $1.totalApps }
    }
    
    var specialtyStats: [UniversitySpecialtyStat] {
        let grouped = Dictionary(grouping: universityApps) { $0.targetSpecialty }
        return grouped.map { specialty, apps in
            UniversitySpecialtyStat(specialtyName: specialty, appCount: apps.count)
        }.sorted { $0.appCount > $1.appCount }
    }
    
    func loadApplicationsForUniversity(_ universityName: String) {
        isLoadingData = true
        currentUniversityName = universityName
        errorMessage = nil
        
        print("🔍 Загружаем заявки для университета: \(universityName)")
        
        let searchNames = getAllUniversityNames(from: universityName)
        print("🔍 Ищем по названиям: \(searchNames)")
        
        firestore.collection("applications")
            .whereField("university", in: searchNames)
            // Убираем .order(by: "submissionDate", descending: true) чтобы не нужен был индекс
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoadingData = false
                    
                    if let error = error {
                        print("❌ Ошибка загрузки заявок: \(error)")
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("📝 Документы не найдены")
                        self?.universityApps = []
                        return
                    }
                    
                    print("📋 Найдено документов: \(documents.count)")
                    
                    var apps = documents.compactMap { doc in
                        let data = doc.data()
                        
                        return UniversityApplicationData(
                            id: doc.documentID,
                            studentFullName: data["fullName"] as? String ?? "",
                            studentEmail: data["email"] as? String ?? "",
                            studentPhone: data["phone"] as? String ?? "",
                            targetUniversity: data["university"] as? String ?? "",
                            targetFaculty: data["faculty"] as? String ?? "",
                            targetSpecialty: data["specialty"] as? String ?? "",
                            currentStatus: data["status"] as? String ?? "pending",
                            submittedAt: (data["submissionDate"] as? Timestamp)?.dateValue() ?? Date(),
                            studentFirstName: data["firstName"] as? String ?? "",
                            studentLastName: data["lastName"] as? String ?? "",
                            studentCity: data["city"] as? String ?? "",
                            studentSchool: data["schoolName"] as? String ?? "",
                            entScore: data["entExamScore"] as? String,
                            avgGrade: data["averageGrade"] as? String,
                            studyLanguage: data["studyLanguage"] as? String ?? "",
                            studyForm: data["studyForm"] as? String ?? ""
                        )
                    }
                    
                    // Сортируем в коде вместо Firebase
                    apps.sort { $0.submittedAt > $1.submittedAt }
                    
                    self?.universityApps = apps
                    print("✅ Обработано заявок: \(apps.count)")
                }
            }
    }
    
    // Функция для получения всех возможных названий университета
    private func getAllUniversityNames(from inputName: String) -> [String] {
        let universityMappings: [String: [String]] = [
            // МУИТ
            "МУИТ": ["МУИТ", "Международный университет информационных технологий"],
            "Международный университет информационных технологий": ["МУИТ", "Международный университет информационных технологий"],
            
            // КазНУ - ДОБАВЛЯЕМ ВСЕ ВАРИАНТЫ
            "КазНУ": ["КазНУ", "КазНУ им. аль-Фараби", "Казахский национальный университет имени аль-Фараби"],
            "КазНУ им. аль-Фараби": ["КазНУ", "КазНУ им. аль-Фараби", "Казахский национальный университет имени аль-Фараби"],
            "Казахский национальный университет имени аль-Фараби": ["КазНУ", "КазНУ им. аль-Фараби", "Казахский национальный университет имени аль-Фараби"],
            
            // КазНТУ
            "КазНТУ": ["КазНТУ", "Казахский национальный технический университет имени К.И. Сатпаева"],
            "Казахский национальный технический университет имени К.И. Сатпаева": ["КазНТУ", "Казахский национальный технический университет имени К.И. Сатпаева"],
            
            // КИМЭП
            "КИМЭП": ["КИМЭП"],
            
            // КБТУ
            "КБТУ": ["КБТУ", "Казахстанско-Британский технический университет"],
            "Казахстанско-Британский технический университет": ["КБТУ", "Казахстанско-Британский технический университет"],
            
            // КазНМУ
            "КазНМУ": ["КазНМУ", "Казахский национальный медицинский университет имени С.Д. Асфендиярова"],
            "Казахский национальный медицинский университет имени С.Д. Асфендиярова": ["КазНМУ", "Казахский национальный медицинский университет имени С.Д. Асфендиярова"]
        ]
        
        // Возвращаем все варианты названий для данного университета
        return universityMappings[inputName] ?? [inputName]
    }
    
    func updateApplicationStatus(appId: String, newStatus: String, completion: @escaping (Bool) -> Void = { _ in }) {
        firestore.collection("applications").document(appId)
            .updateData(["status": newStatus]) { [weak self] error in
                if let error = error {
                    print("❌ Ошибка обновления статуса: \(error)")
                    completion(false)
                } else {
                    print("✅ Статус обновлен на: \(newStatus)")
                    DispatchQueue.main.async {
                        if let index = self?.universityApps.firstIndex(where: { $0.id == appId }) {
                            self?.universityApps[index].currentStatus = newStatus
                        }
                    }
                    completion(true)
                }
            }
    }
    
    func getAppCount(for filter: ApplicationStatusFilter) -> Int {
        switch filter {
        case .allApps:
            return universityApps.count
        default:
            return universityApps.filter { $0.currentStatus == filter.rawValue }.count
        }
    }
}
