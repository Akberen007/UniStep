//
//  ApplicationViewModel.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

// ViewModels/ApplicationViewModel.swift
import Foundation

final class ApplicationViewModel: ObservableObject {
    @Published var applications: [Application] = []

    init() {
        loadApplications()
    }

    func loadApplications() {
        // Загружаем заявки (можно заменить на реальные данные)
        self.applications = [
            Application(applicantName: "Айгерим Садыкова", programName: "Информатика", status: .pending),
            Application(applicantName: "Данияр Бекенов", programName: "Юриспруденция", status: .accepted)
        ]
    }
}
