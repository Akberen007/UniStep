//
//  ApplicationListView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//

import SwiftUI
import Foundation

struct ApplicationListView: View {
    // Пример данных для заявок с обновленной моделью
    let applicants: [Application] = [
        Application(applicantName: "Айдана Ермекова", programName: "Компьютерные науки", status: .accepted, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()),
        Application(applicantName: "Нұрболат Әлімқұлов", programName: "Информационные технологии", status: .pending, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date()),
        Application(applicantName: "Алина Ахметова", programName: "Информационная безопасность", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()),
        Application(applicantName: "Ержан Сейітов", programName: "Программная инженерия", status: .rejected, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date()),
        Application(applicantName: "Әсем Тажибекова", programName: "Data Science", status: .accepted, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date()),
        Application(applicantName: "Алмас Жұмабеков", programName: "Информационные системы", status: .pending, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
        Application(applicantName: "Гүлмира Құралбекова", programName: "Вычислительная техника и ПО", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()),
        Application(applicantName: "Дамир Нұрсейітов", programName: "Журналистика и репортерское дело", status: .rejected, universityShortName: "МУИТ", faculty: "Факультет медиа", submissionDate: Calendar.current.date(byAdding: .day, value: -18, to: Date()) ?? Date()),
        Application(applicantName: "Айнұр Махамбетова", programName: "Менеджмент и управление", status: .accepted, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date()),
        Application(applicantName: "Тимур Батырбеков", programName: "Финансы и экономика", status: .pending, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
        Application(applicantName: "Клара Бейсембаева", programName: "Банковское и страховое дело", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()),
        Application(applicantName: "Жанар Аманжолова", programName: "Коммуникации и телеком", status: .rejected, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -22, to: Date()) ?? Date()),
        Application(applicantName: "Ерасыл Ахмет", programName: "Big Data анализ", status: .accepted, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()),
        Application(applicantName: "Салтанат Кенжебаева", programName: "Кибербезопасность", status: .pending, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
        Application(applicantName: "Алишер Турсынов", programName: "Инженерия программного обеспечения", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
        Application(applicantName: "Мадина Калдыбаева", programName: "Электронный бизнес", status: .rejected, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -16, to: Date()) ?? Date()),
        Application(applicantName: "Бауржан Аман", programName: "Цифровой маркетинг", status: .accepted, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -28, to: Date()) ?? Date()),
        Application(applicantName: "Сабина Омарова", programName: "Мультимедиа технологии", status: .pending, universityShortName: "МУИТ", faculty: "Факультет медиа", submissionDate: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()),
        Application(applicantName: "Диас Сейтжан", programName: "Web-разработка", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
        Application(applicantName: "Карина Абдрахманова", programName: "Сетевые технологии", status: .rejected, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -19, to: Date()) ?? Date()),
        Application(applicantName: "Аружан Серикова", programName: "Технический перевод", status: .accepted, universityShortName: "МУИТ", faculty: "Факультет лингвистики", submissionDate: Calendar.current.date(byAdding: .day, value: -35, to: Date()) ?? Date()),
        Application(applicantName: "Мейрамбек Айдосов", programName: "Цифровые финансы", status: .pending, universityShortName: "МУИТ", faculty: "Бизнес-школа", submissionDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
        Application(applicantName: "Дария Нұрланқызы", programName: "Управление IT-проектами", status: .awaitingDocs, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date()),
        Application(applicantName: "Арман Қайратұлы", programName: "Геймдизайн и разработка игр", status: .rejected, universityShortName: "МУИТ", faculty: "Факультет ИТ", submissionDate: Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date())
    ]
    
    @State private var searchText = "" // Для поиска по имени
    @State private var selectedStatus: Set<ApplicationStatus> = [] // Для выбранных фильтров
    @State private var showFilter = false // Для отображения/скрытия фильтра

    // Фильтрация абитуриентов по статусу и поисковому запросу
    var filteredApplicants: [Application] {
        applicants.filter { applicant in
            (selectedStatus.isEmpty || selectedStatus.contains(applicant.status)) &&  // Фильтрация по статусу
            (searchText.isEmpty || applicant.applicantName.lowercased().contains(searchText.lowercased())) // Фильтрация по имени
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // 🔹 Поиск
            HStack {
                TextField("Поиск абитуриента", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(height: 40)
                
                Button(action: {
                    showFilter.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }

            // 🔹 Фильтры — ближе к полю поиска, не к списку
            if showFilter {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    Button(ApplicationStatus.accepted.displayName) {
                        toggleFilter(status: .accepted)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.accepted), status: .accepted))

                    Button(ApplicationStatus.pending.displayName) {
                        toggleFilter(status: .pending)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.pending), status: .pending))

                    Button(ApplicationStatus.awaitingDocs.displayName) {
                        toggleFilter(status: .awaitingDocs)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.awaitingDocs), status: .awaitingDocs))

                    Button(ApplicationStatus.rejected.displayName) {
                        toggleFilter(status: .rejected)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.rejected), status: .rejected))
                }
                .padding(.horizontal)
            }

            // 🔹 Список абитуриентов
            List(filteredApplicants) { applicant in
                HStack {
                    VStack(alignment: .leading) {
                        Text(applicant.applicantName)
                            .font(.headline)
                        Text("Специализация: \(applicant.programName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    StatusBadge(status: applicant.status)
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
    
    // Функция для переключения фильтров
    func toggleFilter(status: ApplicationStatus) {
        if selectedStatus.contains(status) {
            selectedStatus.remove(status)
        } else {
            selectedStatus.insert(status)
        }
    }
}

// MARK: - Backward Compatibility
// Оставляем старое имя для совместимости, если где-то используется
typealias DemoApplicationsView = ApplicationListView

struct ApplicationListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationListView()
    }
}
