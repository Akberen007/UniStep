import SwiftUI

// Модель заявки
struct Application: Identifiable {
    let id = UUID()
    let applicantName: String
    let programName: String
    let status: ApplicationStatus
}

// Статусы заявки
enum ApplicationStatus: String {
    case accepted = "Принято"
    case pending = "На рассмотрении"
    case awaitingDocs = "Ожидание документов"
    case rejected = "Отклонено"
}

struct DemoApplicationsView: View {
    // Пример данных для заявок
    let applicants: [Application] = [
        Application(applicantName: "Иван Иванов", programName: "Гуманитарные науки", status: .accepted),
        Application(applicantName: "Алина Ахметова", programName: "Цифровой маркетинг", status: .pending),
        Application(applicantName: "Ким Сан", programName: "Естественные науки", status: .awaitingDocs),
        Application(applicantName: "Елена Смирнова", programName: "Биотехнологии", status: .accepted),
        Application(applicantName: "Алексей Петров", programName: "Физика", status: .pending),
        Application(applicantName: "Марина Журавлева", programName: "Социология", status: .awaitingDocs),
        Application(applicantName: "Шолпан Тажиева", programName: "Математика", status: .accepted),
        Application(applicantName: "Бауыржан Нуркенов", programName: "Медицина", status: .rejected),
        
        Application(applicantName: "Нұрболат Әлімқұлов", programName: "Құқықтану", status: .accepted),
        Application(applicantName: "Айгерім Тұрарбекова", programName: "Экономика", status: .pending),
        Application(applicantName: "Ержан Сейітов", programName: "Математика", status: .awaitingDocs),
        Application(applicantName: "Әсем Тажибекова", programName: "Әлеуметтік ғылымдар", status: .accepted),
        Application(applicantName: "Алмас Жұмабеков", programName: "Тарих", status: .pending),
        Application(applicantName: "Гүлмира Құралбекова", programName: "Биология", status: .rejected),
        Application(applicantName: "Дамир Нұрсейітов", programName: "Педагогика", status: .accepted),
        Application(applicantName: "Айнұр Махамбетова", programName: "Физика", status: .awaitingDocs),
        Application(applicantName: "Самал Қаржаубаева", programName: "Медициналық ғылымдар", status: .pending),
        Application(applicantName: "Тимур Батырбеков", programName: "Қаржы", status: .accepted),
        Application(applicantName: "Клара Бейсембаева", programName: "Кітапхана ісі", status: .rejected),
        Application(applicantName: "Жанар Аманжолова", programName: "Экология", status: .pending),
        Application(applicantName: "Қанат Жанабаев", programName: "Кәсіпкерлік", status: .accepted),
        Application(applicantName: "Лаура Нұрмұхамбетова", programName: "Медицина", status: .awaitingDocs),
        Application(applicantName: "Марат Бекетұлы", programName: "Информатика", status: .rejected)
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
        VStack {
            // Поиск абитуриента
            HStack {
                TextField("Поиск абитуриента", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(height: 40)
                
                Button(action: {
                    showFilter.toggle() // Показываем/скрываем фильтр
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }

            // Фильтры
            if showFilter {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    Button("Одобрено") {
                        toggleFilter(status: .accepted)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.accepted)))

                    Button("На рассмотрении") {
                        toggleFilter(status: .pending)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.pending)))

                    Button("Ожидание документов") {
                        toggleFilter(status: .awaitingDocs)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.awaitingDocs)))
                    
                    Button("Отклонено") {
                        toggleFilter(status: .rejected) // Новый фильтр для отклоненных
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.rejected)))
                }
                .padding(.horizontal)
            }

            // Список абитуриентов
            List(filteredApplicants) { applicant in
                HStack {
                    VStack(alignment: .leading) {
                        Text(applicant.applicantName)
                            .font(.headline)
                        Text("Сфера университета: \(applicant.programName)")
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

struct FilteredButtonStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .frame(height: 40)
    }
}

// Статус для заявки
struct StatusBadge: View {
    var status: ApplicationStatus

    var body: some View {
        Circle()
            .fill(statusColor(status))  // Круг, цвет зависит от статуса
            .frame(width: 10, height: 10)
    }
    
    func statusColor(_ status: ApplicationStatus) -> Color {
        switch status {
        case .accepted:
            return .green // Зеленый для "Принято"
        case .pending:
            return .orange // Оранжевый для "На рассмотрении"
        case .awaitingDocs:
            return .gray // Серый для "Ожидание документов"
        case .rejected:
            return .red // Красный для "Отклонено"
        }
    }
}

struct DemoApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        DemoApplicationsView()
    }
}
