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
        Application(applicantName: "Айдана Ермекова", programName: "Компьютерные науки", status: .accepted),
        Application(applicantName: "Нұрболат Әлімқұлов", programName: "Информационные технологии", status: .pending),
        Application(applicantName: "Алина Ахметова", programName: "Информационная безопасность", status: .awaitingDocs),
        Application(applicantName: "Ержан Сейітов", programName: "Программная инженерия", status: .rejected),
        Application(applicantName: "Әсем Тажибекова", programName: "Data Science", status: .accepted),
        Application(applicantName: "Алмас Жұмабеков", programName: "Информационные системы", status: .pending),
        Application(applicantName: "Гүлмира Құралбекова", programName: "Вычислительная техника и ПО", status: .awaitingDocs),
        Application(applicantName: "Дамир Нұрсейітов", programName: "Журналистика и репортерское дело", status: .rejected),
        Application(applicantName: "Айнұр Махамбетова", programName: "Менеджмент и управление", status: .accepted),
        Application(applicantName: "Тимур Батырбеков", programName: "Финансы и экономика", status: .pending),
        Application(applicantName: "Клара Бейсембаева", programName: "Банковское и страховое дело", status: .awaitingDocs),
        Application(applicantName: "Жанар Аманжолова", programName: "Коммуникации и телеком", status: .rejected),
        Application(applicantName: "Ерасыл Ахмет", programName: "Big Data анализ", status: .accepted),
        Application(applicantName: "Салтанат Кенжебаева", programName: "Кибербезопасность", status: .pending),
        Application(applicantName: "Алишер Турсынов", programName: "Инженерия программного обеспечения", status: .awaitingDocs),
        Application(applicantName: "Мадина Калдыбаева", programName: "Электронный бизнес", status: .rejected),
        Application(applicantName: "Бауржан Аман", programName: "Цифровой маркетинг", status: .accepted),
        Application(applicantName: "Сабина Омарова", programName: "Мультимедиа технологии", status: .pending),
        Application(applicantName: "Диас Сейтжан", programName: "Web-разработка", status: .awaitingDocs),
        Application(applicantName: "Карина Абдрахманова", programName: "Сетевые технологии", status: .rejected),
        Application(applicantName: "Аружан Серикова", programName: "Технический перевод", status: .accepted),
        Application(applicantName: "Мейрамбек Айдосов", programName: "Цифровые финансы", status: .pending),
        Application(applicantName: "Дария Нұрланқызы", programName: "Управление IT-проектами", status: .awaitingDocs),
        Application(applicantName: "Арман Қайратұлы", programName: "Геймдизайн и разработка игр", status: .rejected)
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
                    Button("Одобрено") {
                        toggleFilter(status: .accepted)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.accepted), status: .accepted))

                    Button("На рассмотрении") {
                        toggleFilter(status: .pending)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.pending), status: .pending))

                    Button("Ожидание документов") {
                        toggleFilter(status: .awaitingDocs)
                    }
                    .buttonStyle(FilteredButtonStyle(isSelected: selectedStatus.contains(.awaitingDocs), status: .awaitingDocs))

                    Button("Отклонено") {
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

//struct FilteredButtonStyle: ButtonStyle {
//    var isSelected: Bool
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding(.horizontal, 15)
//            .padding(.vertical, 10)
//            .background(isSelected ? Color.blue : Color.gray)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .frame(height: 40)
//    }
//}

struct DemoApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        DemoApplicationsView()
    }
}
