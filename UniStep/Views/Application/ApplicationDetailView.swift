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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок
                Text("Детали заявки")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Имя абитуриента
                Text("ФИО: \(application.applicantName)")
                    .font(.title2)

                // Программа обучения
                Text("Программа: \(application.programName)")
                    .font(.title3)
                    .foregroundColor(.gray)

                // Статус заявки
                HStack {
                    Text("Статус: ")
                        .font(.headline)
                    StatusBadge(status: application.status)
                }

                // Раздел с дополнительной информацией
                Text("Личные данные")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Дата рождения: 01.01.2000")
                    Text("Гражданство: Казахстан")
                    Text("Контакты: +7 777 123 45 67 | email@example.com")
                    Text("Адрес проживания: г. Алматы, ул. Абая 12")
                }

                // Документы
                Text("Документы об образовании")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Аттестат / диплом: Загружен")
                    Text("Приложение с оценками: Загружено")
                }

                // Результаты экзаменов
                Text("Результаты экзаменов")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("ЕНТ: 120 баллов")
                    Text("Внутренние экзамены: 85 баллов")
                }

                // Дополнительные документы
                Text("Дополнительные документы")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Паспорт: Загружен")
                    Text("Медсправка: Загружена")
                    Text("Фото: Загружено")
                    Text("Справка о прививках: Загружена")
                }

                // Дополнительные требования
                Text("Дополнительные требования")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Мотивационное письмо: Загружено")
                    Text("Рекомендации: Загружены")
                    Text("Портфолио: Загружено")
                    Text("Сертификаты IELTS, TOEFL: Загружены")
                    Text("Дипломы, грамоты: Загружены")
                }

                Spacer()
            }
            .padding()
        }
    }
}
