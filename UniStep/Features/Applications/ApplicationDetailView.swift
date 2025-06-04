//
//  ApplicationDetailView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

// Views/ApplicationDetailView.swift
import SwiftUI

struct ApplicationDetailView: View {
    let application: Application
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок с статусом
                VStack(spacing: 16) {
                    StatusBadge(status: application.status)
                        .scaleEffect(1.2)
                    
                    Text(application.applicantName)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(application.programName)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

                // Личные данные
                SectionView(title: "Личные данные") {
                    InfoRow(label: "ФИО", value: application.applicantName)
                    InfoRow(label: "Дата рождения", value: "01.01.2000")
                    InfoRow(label: "Гражданство", value: "Казахстан")
                    InfoRow(label: "Телефон", value: "+7 777 123 45 67")
                    InfoRow(label: "Email", value: "email@example.com")
                    InfoRow(label: "Адрес", value: "г. Алматы, ул. Абая 12")
                }

                // Образование
                SectionView(title: "Документы об образовании") {
                    DocumentRow(name: "Аттестат/диплом", status: .uploaded)
                    DocumentRow(name: "Приложение с оценками", status: .uploaded)
                }

                // Результаты экзаменов
                SectionView(title: "Результаты экзаменов") {
                    InfoRow(label: "ЕНТ", value: "120 баллов")
                    InfoRow(label: "Внутренние экзамены", value: "85 баллов")
                }

                // Дополнительные документы
                SectionView(title: "Дополнительные документы") {
                    DocumentRow(name: "Паспорт", status: .uploaded)
                    DocumentRow(name: "Медсправка", status: .uploaded)
                    DocumentRow(name: "Фото 3x4", status: .uploaded)
                    DocumentRow(name: "Справка о прививках", status: .uploaded)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Детали заявки")
        .navigationBarTitleDisplayMode(.inline)
    }
}
