//  ApplicationFormView.swift
//  UniStep
//
//  Created by Assistant on 31.05.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ApplicationFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var showSuccess = false
    @State private var navigateToSuccess = false
    
    // Firebase states
    @State private var isSubmitting = false
    @State private var submitError: String?
    
    // Personal Info
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var middleName = ""
    @State private var birthDate = Date()
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var iin = ""
    
    // Validation states
    @State private var emailError = ""
    @State private var phoneError = ""
    @State private var iinError = ""
    @State private var nameError = ""
    
    // State for date picker
    @State private var showDatePicker = false
    
    // Address Info
    @State private var city = ""
    @State private var address = ""
    @State private var postalCode = ""
    
    // Education Info
    @State private var schoolName = ""
    @State private var graduationYear = ""
    @State private var averageGrade = ""
    @State private var entExamScore = ""
    
    // University Selection
    @State private var selectedUniversity = ""
    @State private var selectedFaculty = ""
    @State private var selectedSpecialty = ""
    @State private var customSpecialty = ""
    @State private var studyLanguage = "Казахский"
    @State private var studyForm = "Очная"
    
    // Documents
    @State private var hasPassport = false
    @State private var hasCertificate = false
    @State private var hasEntResults = false
    @State private var hasPhotos = false
    @State private var hasMedical = false
    
    @State private var submittedApplicationId = ""

    let steps = ["Личные данные", "Адрес", "Образование", "Специальность", "Документы"]
    
    // MARK: - University Display Mapping
    let universityDisplayNames: [String: String] = [
        "МУИТ": "Международный университет информационных технологий",
        "КазНУ": "Казахский национальный университет им. аль-Фараби",
        "КазНТУ": "Казахский национальный технический университет им. К.И. Сатпаева",
        "КИМЭП": "КИМЭП",
        "НУ": "Назарбаев Университет",
        "КазНМУ": "Казахский национальный медицинский университет им. С.Д. Асфендиярова",
        "КазНПУ": "Казахский национальный педагогический университет им. Абая",
        "КазГЮУ": "Казахский гуманитарно-юридический университет им. М.С. Нарикбаева",
        "КазАТУ": "Казахский агротехнический университет им. С. Сейфуллина",
        "АУЭС": "Алматинский университет энергетики и связи",
        "КазЭУ": "Казахский экономический университет им. Т. Рыскулова",
        "КБТУ": "Казахстанско-Британский технический университет",
        "ЕНУ": "Евразийский национальный университет им. Л.Н. Гумилева"
    ]

    // Структура: Университет -> Факультеты -> Специальности
    let universitiesData: [String: [String: [String]]] = [
        "МУИТ": [
            "Факультет информационных технологий": ["Информационные системы", "Программная инженерия", "Кибербезопасность", "Искусственный интеллект", "Веб-разработка", "Мобильная разработка"],
            "Факультет компьютерных наук": ["Компьютерные науки", "Наука о данных", "Машинное обучение", "Большие данные", "Блокчейн технологии"],
            "Факультет телекоммуникаций": ["Телекоммуникации", "Сетевые технологии", "Радиотехника", "Спутниковые системы"],
            "Факультет цифровых технологий": ["Цифровой дизайн", "UX/UI дизайн", "Геймдизайн", "3D моделирование", "Анимация"],
            "Факультет робототехники": ["Робототехника", "Мехатроника", "Автоматизация", "IoT технологии"],
            "Бизнес-факультет": ["IT-менеджмент", "Цифровой маркетинг", "E-commerce", "Стартапы и инновации"]
        ],
        
        "КазНУ": [
            "Факультет информационных технологий": ["Информационные системы", "Программная инженерия", "Кибербезопасность"],
            "Экономический факультет": ["Экономика", "Менеджмент", "Маркетинг", "Финансы", "Международная экономика", "Бухгалтерский учет и аудит"],
            "Юридический факультет": ["Юриспруденция", "Международное право", "Таможенное дело"],
            "Факультет международных отношений": ["Международные отношения", "Дипломатия", "Регионоведение", "Политология"],
            "Филологический факультет": ["Казахская филология", "Русская филология", "Английская филология", "Переводческое дело", "Лингвистика"],
            "Факультет журналистики": ["Журналистика", "Телерадиожурналистика", "Реклама и PR"],
            "Исторический факультет": ["История", "Археология", "Этнология", "Музееведение"],
            "Географический факультет": ["География", "Экология", "Туризм", "Картография"],
            "Физический факультет": ["Физика", "Ядерная физика", "Радиофизика"],
            "Химический факультет": ["Химия", "Химическая технология", "Нефтехимия"],
            "Биологический факультет": ["Биология", "Биотехнология", "Экология"],
            "Математический факультет": ["Математика", "Прикладная математика", "Актуарная математика"]
        ],
        
        "КазНТУ": [
            "Инженерный факультет": ["Машиностроение", "Приборостроение", "Металлургия", "Материаловедение", "Автоматизация"],
            "Факультет информационных технологий": ["Программная инженерия", "Информационные системы"],
            "Горно-металлургический факультет": ["Горное дело", "Металлургия", "Обогащение полезных ископаемых", "Маркшейдерское дело"],
            "Энергетический факультет": ["Электроэнергетика", "Теплоэнергетика", "Возобновляемая энергетика", "Ядерная энергетика"],
            "Нефтегазовый факультет": ["Нефтегазовое дело", "Бурение скважин", "Разработка месторождений", "Переработка нефти"],
            "Строительный факультет": ["Промышленное строительство", "Гражданское строительство", "Архитектура"],
            "Транспортный факультет": ["Автомобильный транспорт", "Железнодорожный транспорт", "Логистика"]
        ],
        
        "КИМЭП": [
            "Бизнес-школа": ["Менеджмент", "Маркетинг", "Финансы", "Международный бизнес", "Предпринимательство", "Управление персоналом"],
            "Юридическая школа": ["Юриспруденция", "Международное право", "Корпоративное право"],
            "Школа государственной политики": ["Государственное управление", "Международные отношения", "Политология"],
            "Факультет экономики": ["Экономика", "Международная экономика", "Экономическая аналитика"]
        ],
        
        "НУ": [
            "Школа инженерии и цифровых наук": ["Химическая инженерия", "Гражданская инженерия", "Электротехника", "Компьютерные науки"],
            "Школа наук и технологий": ["Математика", "Физика", "Химия", "Биология", "Наука о данных"],
            "Назарбаев Бизнес-школа": ["Менеджмент", "Финансы", "Международный бизнес"],
            "Медицинская школа": ["Медицина", "Биомедицинские науки"],
            "Высшая школа образования": ["Педагогические науки", "Образовательные технологии"]
        ],
        
        "КазНМУ": [
            "Медицинский факультет": ["Лечебное дело", "Педиатрия", "Медико-профилактическое дело"],
            "Стоматологический факультет": ["Стоматология", "Детская стоматология"],
            "Фармацевтический факультет": ["Фармация", "Клиническая фармация"],
            "Факультет общественного здравоохранения": ["Общественное здравоохранение", "Биостатистика"],
            "Факультет послевузовского образования": ["Ординатура", "Магистратура по медицине"]
        ],
        
        "КазНПУ": [
            "Педагогический факультет": ["Начальное образование", "Дошкольное образование", "Социальная педагогика"],
            "Факультет искусств": ["Музыкальное образование", "Изобразительное искусство", "Хореография", "Дизайн"],
            "Филологический факультет": ["Казахский язык и литература", "Русский язык и литература", "Английский язык", "Переводческое дело"],
            "Исторический факультет": ["История", "Археология", "Культурология"],
            "Физико-математический факультет": ["Математика", "Физика", "Информатика"],
            "Факультет психологии": ["Психология", "Социальная работа"]
        ],
        
        "КазГЮУ": [
            "Юридический факультет": ["Юриспруденция", "Правоохранительная деятельность"],
            "Факультет международного права": ["Международное право", "Международные отношения"],
            "Факультет экономики и права": ["Экономика и право", "Таможенное дело"],
            "Факультет цифрового права": ["Цифровое право", "Кибербезопасность в праве"]
        ],
        
        "КазАТУ": [
            "Агрономический факультет": ["Агрономия", "Плодоовощеводство", "Селекция растений"],
            "Факультет ветеринарной медицины": ["Ветеринария", "Ветеринарно-санитарная экспертиза"],
            "Факультет механизации": ["Механизация сельского хозяйства", "Автомобили и автомобильное хозяйство"],
            "Экономический факультет": ["Экономика", "Менеджмент", "Учет и аудит"],
            "Факультет водных ресурсов": ["Водные ресурсы и водопользование", "Гидротехнические сооружения"]
        ],
        
        "АУЭС": [
            "Энергетический факультет": ["Электроэнергетика", "Теплоэнергетика", "Возобновляемая энергетика"],
            "Факультет автоматики и телекоммуникаций": ["Автоматизация", "Телекоммуникации"],
            "Факультет информационных технологий": ["Информационные системы"],
            "Инженерно-экологический факультет": ["Экология", "Безопасность жизнедеятельности"]
        ],
        
        "КазЭУ": [
            "Экономический факультет": ["Экономика", "Международная экономика", "Экономическая безопасность"],
            "Факультет бизнеса": ["Менеджмент", "Маркетинг", "Логистика"],
            "Финансовый факультет": ["Финансы", "Банковское дело", "Страхование"],
            "Факультет учета и аудита": ["Бухгалтерский учет и аудит", "Налоги и налогообложение"],
            "Факультет информационных технологий": ["Информационные системы", "Цифровая экономика"]
        ],
        
        "КБТУ": [
            "Факультет информационных технологий": ["Информационные системы", "Кибербезопасность"],
            "Инженерный факультет": ["Нефтегазовая инженерия", "Химическая инженерия", "Промышленная инженерия"],
            "Бизнес-факультет": ["Менеджмент", "Финансы", "Маркетинг", "Предпринимательство"],
            "Факультет наук о Земле": ["Геология", "Геофизика", "Нефтяная геология"]
        ],
        
        "ЕНУ": [
            "Факультет информационных технологий": ["Информационные системы"],
            "Экономический факультет": ["Экономика", "Менеджмент", "Маркетинг", "Финансы"],
            "Юридический факультет": ["Юриспруденция", "Международное право"],
            "Педагогический факультет": ["Педагогика и психология", "Дошкольное обучение"],
            "Филологический факультет": ["Казахская филология", "Русская филология", "Иностранная филология"],
            "Факультет естественных наук": ["Биология", "Химия", "География", "Экология"]
        ]
    ]
    
    // ✅ ОБНОВЛЕННЫЕ computed properties с комбинированными названиями
    var universities: [String] {
        return Array(universitiesData.keys)
            .sorted()
            .compactMap { shortName in
                guard let fullName = universityDisplayNames[shortName] else { return nil }
                return getCombinedDisplayName(shortName: shortName, fullName: fullName)
            }
    }

    var availableFaculties: [String] {
        guard !selectedUniversity.isEmpty else { return [] }
        let shortName = getShortNameFromCombined(selectedUniversity)
        print("🔍 DEBUG: selectedUniversity = '\(selectedUniversity)'")
        print("🔍 DEBUG: извлеченное shortName = '\(shortName)'")
        
        guard let faculties = universitiesData[shortName] else {
            print("❌ DEBUG: Факультеты не найдены для '\(shortName)'")
            return []
        }
        print("✅ DEBUG: Найдено \(faculties.keys.count) факультетов")
        return Array(faculties.keys).sorted()
    }

    var availableSpecialties: [String] {
        guard !selectedUniversity.isEmpty, !selectedFaculty.isEmpty else { return [] }
        let shortName = getShortNameFromCombined(selectedUniversity)
        guard let faculties = universitiesData[shortName],
              let specialties = faculties[selectedFaculty] else { return [] }
        return specialties.sorted()
    }
    
    let languages = ["Казахский", "Русский", "Английский"]
    let studyForms = ["Очная", "Заочная", "Дистанционная"]
    
    // MARK: - Firebase Submit Function (ИСПРАВЛЕННАЯ)
    private func submitApplication() {
        isSubmitting = true
        submitError = nil
        
        let db = Firestore.firestore()
        
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let finalSpecialty = selectedSpecialty == "Другое..." ? customSpecialty : selectedSpecialty
        
        // ✅ ИСПРАВЛЕНИЕ: Извлекаем короткое название для сохранения в Firebase
        let universityToSave = getShortNameFromCombined(selectedUniversity)
        let applicationId = generateApplicationId()
        
        print("🔍 DEBUG СОХРАНЕНИЕ:")
        print("   selectedUniversity (комбинированное): '\(selectedUniversity)'")
        print("   universityToSave (короткое): '\(universityToSave)'")
        print("   applicationId: '\(applicationId)'")
        
        let applicationData: [String: Any] = [
            "id": applicationId, // ✅ Используем сгенерированный ID
            "studentId": Auth.auth().currentUser?.uid ?? "anonymous",
            "status": "pending",
            "submissionDate": Timestamp(date: Date()),
            
            // Personal Info
            "firstName": firstName,
            "lastName": lastName,
            "middleName": middleName,
            "fullName": fullName,
            "birthDate": Timestamp(date: birthDate),
            "email": email,
            "phone": phoneNumber,
            "iin": iin,
            
            // Address
            "city": city,
            "address": address,
            "postalCode": postalCode,
            
            // Education
            "schoolName": schoolName,
            "graduationYear": graduationYear,
            "averageGrade": averageGrade,
            "entExamScore": entExamScore,
            
            // University Selection
            "university": universityToSave, // ✅ Сохраняем короткое название
            "faculty": selectedFaculty,
            "specialty": finalSpecialty,
            "studyLanguage": studyLanguage,
            "studyForm": studyForm,
            
            // Documents
            "documents": [
                "hasPassport": hasPassport,
                "hasCertificate": hasCertificate,
                "hasEntResults": hasEntResults,
                "hasPhotos": hasPhotos,
                "hasMedical": hasMedical,
                "allDocumentsReady": allDocumentsChecked
            ]
        ]
        
        db.collection("applications").addDocument(data: applicationData) { error in
            DispatchQueue.main.async {
                isSubmitting = false
                
                if let error = error {
                    print("❌ Ошибка сохранения: \(error)")
                    submitError = "Ошибка отправки заявки. Попробуйте еще раз."
                } else {
                    print("✅ Заявка сохранена в Firebase с ID: '\(applicationId)'")
                    // ✅ ИСПРАВЛЕНИЕ: Сохраняем ID для передачи в Success экран
                    submittedApplicationId = applicationId
                    navigateToSuccess = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                progressBar
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Step Content
                        stepContent
                        
                        // Navigation Buttons
                        navigationButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Подача заявки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(selectedDate: $birthDate, isPresented: $showDatePicker)
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.visible)
            }
            // ✅ ИСПРАВЛЕНИЕ: Передаем applicationId в Success экран
            .navigationDestination(isPresented: $navigateToSuccess) {
                ApplicationSuccessView(
                    applicantName: "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces),
                    university: selectedUniversity, // Показываем комбинированное название
                    faculty: selectedFaculty,
                    specialty: selectedSpecialty == "Другое..." ? customSpecialty : selectedSpecialty,
                    phone: phoneNumber,
                    email: email,
                    applicationId: submittedApplicationId // ✅ ДОБАВЛЯЕМ ID заявки
                )
            }
        }
    }
        
    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(0..<steps.count, id: \.self) { index in
                    HStack(spacing: 0) {
                        Circle()
                            .fill(index <= currentStep ? Color.red : Color.gray.opacity(0.3))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(index + 1)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(index <= currentStep ? .white : .gray)
                            )
                        
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(index < currentStep ? Color.red : Color.gray.opacity(0.3))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            
            Text(steps[currentStep])
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
        
    // MARK: - Step Content
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            personalInfoStep
        case 1:
            addressInfoStep
        case 2:
            educationInfoStep
        case 3:
            universitySelectionStep
        case 4:
            documentsStep
        default:
            EmptyView()
        }
    }
        
    // MARK: - Personal Info Step
    private var personalInfoStep: some View {
        VStack(spacing: 20) {
            StepHeader(
                icon: "person.fill",
                title: "Личная информация",
                subtitle: "Введите ваши персональные данные"
            )
            
            VStack(spacing: 16) {
                CustomTextField(title: "Фамилия", text: $lastName, systemImage: "person")
                CustomTextField(title: "Имя", text: $firstName, systemImage: "person")
                CustomTextField(title: "Отчество", text: $middleName, systemImage: "person")
                
                // Кастомное поле даты как кнопка
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                        
                        Button(action: {
                            showDatePicker = true
                        }) {
                            HStack {
                                Text(formatDate(birthDate))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(height: 48)
                    .padding(.horizontal)
                }
                
                CustomTextField(title: "ИИН", text: $iin, systemImage: "person.text.rectangle")
                CustomTextField(title: "+7 (777) 123-45-67", text: $phoneNumber, systemImage: "phone")
                CustomTextField(title: "example@mail.com", text: $email, systemImage: "envelope")
            }
        }
    }
        
    // MARK: - Address Info Step
    private var addressInfoStep: some View {
        VStack(spacing: 20) {
            StepHeader(
                icon: "location.fill",
                title: "Адрес проживания",
                subtitle: "Укажите ваш текущий адрес"
            )
            
            VStack(spacing: 16) {
                CustomTextField(title: "Город", text: $city, systemImage: "building.2")
                CustomTextField(title: "Адрес", text: $address, systemImage: "location")
                CustomTextField(title: "Почтовый индекс", text: $postalCode, systemImage: "envelope.fill")
            }
        }
    }
        
    // MARK: - Education Info Step
    private var educationInfoStep: some View {
        VStack(spacing: 20) {
            StepHeader(
                icon: "graduationcap.fill",
                title: "Образование",
                subtitle: "Информация о вашем образовании"
            )
            
            VStack(spacing: 16) {
                CustomTextField(title: "Название школы/колледжа", text: $schoolName, systemImage: "building.columns")
                CustomTextField(title: "Год окончания", text: $graduationYear, systemImage: "calendar")
                CustomTextField(title: "Средний балл аттестата", text: $averageGrade, systemImage: "star.fill")
                CustomTextField(title: "Балл ЕНТ/КТА", text: $entExamScore, systemImage: "doc.text")
            }
        }
    }
        
    // MARK: - University Selection Step
    private var universitySelectionStep: some View {
        VStack(spacing: 20) {
            StepHeader(
                icon: "building.columns.fill",
                title: "Выбор специальности",
                subtitle: "Выберите университет и направление"
            )
            
            VStack(spacing: 16) {
                CustomPicker(title: "Университет", selection: $selectedUniversity, options: universities)
                    .onChange(of: selectedUniversity) { _ in
                        // Сбрасываем выбор факультета и специальности при смене университета
                        selectedFaculty = ""
                        selectedSpecialty = ""
                        customSpecialty = ""
                    }
                
                if !selectedUniversity.isEmpty {
                    CustomPicker(title: "Факультет", selection: $selectedFaculty, options: availableFaculties)
                        .onChange(of: selectedFaculty) { _ in
                            // Сбрасываем выбор специальности при смене факультета
                            selectedSpecialty = ""
                            customSpecialty = ""
                        }
                }
                
                if !selectedFaculty.isEmpty {
                    if !availableSpecialties.isEmpty {
                        CustomPicker(title: "Специальность", selection: $selectedSpecialty, options: availableSpecialties + ["Другое..."])
                    } else {
                        CustomTextField(title: "Специальность", text: $customSpecialty, systemImage: "book")
                    }
                }
                
                // Показываем поле для ввода, если выбрано "Другое..."
                if selectedSpecialty == "Другое..." {
                    CustomTextField(title: "Укажите специальность", text: $customSpecialty, systemImage: "pencil")
                }
                
                if !selectedUniversity.isEmpty {
                    CustomPicker(title: "Язык обучения", selection: $studyLanguage, options: languages)
                    CustomPicker(title: "Форма обучения", selection: $studyForm, options: studyForms)
                }
            }
        }
    }
        
    // MARK: - Documents Step
        private var documentsStep: some View {
            VStack(spacing: 20) {
                StepHeader(
                    icon: "doc.fill",
                    title: "Документы",
                    subtitle: "Отметьте имеющиеся документы"
                )
                
                VStack(spacing: 12) {
                    DocumentCheckRow(title: "Документ, удостоверяющий личность", isChecked: $hasPassport)
                    DocumentCheckRow(title: "Документ об образовании", isChecked: $hasCertificate)
                    DocumentCheckRow(title: "Результаты ЕНТ/КТА", isChecked: $hasEntResults)
                    DocumentCheckRow(title: "Фотографии 3x4 (6 шт.)", isChecked: $hasPhotos)
                    DocumentCheckRow(title: "Медицинская справка", isChecked: $hasMedical)
                }
                
                if !allDocumentsChecked {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                            Text("Внимание")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                            Spacer()
                        }
                        
                        Text("Для подачи заявки необходимо подготовить все документы. Вы можете подать заявку сейчас и донести документы позже.")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(12)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
            
        // MARK: - Navigation Buttons (обновленные с Firebase состояниями)
        private var navigationButtons: some View {
            VStack(spacing: 12) {
                // Показываем ошибку если есть
                if let error = submitError {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                
                HStack(spacing: 12) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }) {
                            Text("Назад")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        }
                        .disabled(isSubmitting)
                    }
                    
                    Button(action: {
                        if currentStep < steps.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        } else {
                            // Submit application
                            submitApplication()
                        }
                    }) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            Text(isSubmitting ? "Отправка..." :
                                 currentStep < steps.count - 1 ? "Далее" : "Подать заявку")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(canProceed && !isSubmitting ? Color.red : Color.gray.opacity(0.6))
                        )
                    }
                    .disabled(!canProceed || isSubmitting)
                }
                .padding(.top, 8)
            }
        }
            
        // MARK: - Computed Properties
        private var canProceed: Bool {
            // Временно убираем валидацию для тестирования
            return true
        }
            
        private var allDocumentsChecked: Bool {
            hasPassport && hasCertificate && hasEntResults && hasPhotos && hasMedical
        }
            
        // Date formatter for display
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }
            
        // MARK: - Validation Methods
        private func validateEmail(_ email: String) {
            if email.isEmpty {
                emailError = ""
                return
            }
            
            let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            if !emailTest.evaluate(with: email) {
                emailError = "Неверный формат email"
            } else {
                emailError = ""
            }
        }
            
        private func validatePhone(_ phone: String) {
            if phone.isEmpty {
                phoneError = ""
                return
            }
            
            // Remove all non-digit characters for validation
            let digits = phone.filter { $0.isNumber }
            
            if digits.count < 11 {
                phoneError = "Номер телефона должен содержать 11 цифр"
            } else if digits.count > 11 {
                phoneError = "Номер телефона слишком длинный"
            } else if !digits.hasPrefix("7") {
                phoneError = "Номер должен начинаться с +7"
            } else {
                phoneError = ""
            }
        }
            
        private func validateIIN(_ iin: String) {
            if iin.isEmpty {
                iinError = ""
                return
            }
            
            let digits = iin.filter { $0.isNumber }
            
            if digits.count != 12 {
                iinError = "ИИН должен содержать 12 цифр"
            } else {
                // Basic IIN validation for Kazakhstan
                let firstSix = String(digits.prefix(6))
                if let birthYear = Int(firstSix.prefix(2)) {
                    let currentYear = Calendar.current.component(.year, from: Date()) % 100
                    if birthYear > currentYear + 10 { // Simple check
                        iinError = "Проверьте правильность ИИН"
                    } else {
                        iinError = ""
                    }
                } else {
                    iinError = "Неверный формат ИИН"
                }
            }
        }
            
        private func validateStep() {
            switch currentStep {
            case 0:
                nameError = firstName.isEmpty || lastName.isEmpty ? "Заполните обязательные поля" : ""
                validateEmail(email)
                validatePhone(phoneNumber)
                validateIIN(iin)
            default:
                break
            }
        }
            
        // Date formatting function
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter.string(from: date)
        }
    }

    // MARK: - University Helper Extension
    extension ApplicationFormView {
        
        // ✅ ФУНКЦИЯ: Создает комбинированное отображение
        func getCombinedDisplayName(shortName: String, fullName: String) -> String {
            if shortName == fullName {
                // Если названия одинаковые (как КИМЭП), показываем только одно
                return fullName
            } else {
                // Показываем полное название + сокращение в скобках
                return "\(fullName) (\(shortName))"
            }
        }

        // ✅ ФУНКЦИЯ: Извлекает короткое название из комбинированного
        func getShortNameFromCombined(_ combinedName: String) -> String {
            // Если есть скобки, извлекаем содержимое
            if let openBracket = combinedName.lastIndex(of: "("),
               let closeBracket = combinedName.lastIndex(of: ")") {
                let shortName = String(combinedName[combinedName.index(after: openBracket)..<closeBracket])
                return shortName
            }
            
            // Если скобок нет, ищем соответствие в словаре
            for (shortName, fullName) in universityDisplayNames {
                if fullName == combinedName {
                    return shortName
                }
            }
            
            return combinedName
        }

        // ✅ ФУНКЦИЯ: Получает полное название из короткого
        func getDisplayName(from shortName: String) -> String {
            return universityDisplayNames[shortName] ?? shortName
        }
        
        // ✅ ФУНКЦИЯ: Генерация ID заявки в правильном формате
        func generateApplicationId() -> String {
            let currentYear = Calendar.current.component(.year, from: Date())
            let randomNumber = Int.random(in: 1000...9999)
            return "AB\(currentYear)-\(randomNumber)"
        }
    }

    // MARK: - Закрывающая скобка структуры
