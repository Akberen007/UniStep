
//
//  HomeView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//
import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @State private var showContent = false
    @State private var showApplicationForm = false
    @State private var showStatusCheck = false
    @State private var showDocuments = false
    @State private var showDeadlines = false
    @State private var showCalculator = false
    @State private var showHelp = false
    @State private var animateCards = false
    @State private var navigateToUniversities = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // 🔹 Header
                        headerSection
                        
                        // 🔹 Hero Section
                        heroSection
                        
                        // 🔹 Quick Actions
                        quickActionsSection
                            .opacity(animateCards ? 1 : 0)
                            .offset(x: animateCards ? 0 : -30)
                            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.2), value: animateCards)
                        
                        // 🔹 Tools Section
                        toolsSection
                            .opacity(animateCards ? 1 : 0)
                            .offset(x: animateCards ? 0 : 30)
                            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.3), value: animateCards)
                        
                        // 🔹 Footer
                        footerSection
                            .opacity(animateCards ? 1 : 0)
                            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.4), value: animateCards)
                    }
                    .padding(.bottom, max(20, geometry.safeAreaInsets.bottom))
                }
                .scrollIndicators(.hidden)
            }
            .background(
                LinearGradient(
                    colors: [Color.uniBackground ?? Color.gray.opacity(0.1), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        animateCards = true
                    }
                }
                TestDataCreator.shared.createTestApplicationsIfNeeded()
            }
            // Навигация
            .navigationDestination(isPresented: $navigateToUniversities) {
                UniversitiesCatalogView()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                RoleSelectionView() // Панель для университетов
            }
            // Sheets
            .sheet(isPresented: $showApplicationForm) {
                ApplicationFormView()
            }
            .sheet(isPresented: $showStatusCheck) {
                StatusCheckView()
            }
            .sheet(isPresented: $showDocuments) {
                DocumentsView()
            }
            .sheet(isPresented: $showDeadlines) {
                DeadlinesView()
            }
            .sheet(isPresented: $showCalculator) {
                CalculatorView()
            }
            .sheet(isPresented: $showHelp) {
                HelpView()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    // Используем системную иконку если Image("books1") не найден
                    Group {
                        if let _ = UIImage(named: "books1") {
                            Image("books1")
                                .resizable()
                                .frame(width: 26, height: 30)
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.red)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("UniStep")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Приемная кампания 2025")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Уведомления
                NotificationButton(hasNotification: true) {
                    print("Notifications tapped")
                }
                
                // Профиль
                Button(action: {
                    print("University panel tapped")
                    navigateToLogin = true
                }) {
                    ProfileButton()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : -20)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 0) {
            SlideView()
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.95)
                .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1), value: showContent)
                .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Quick Actions Section
        private var quickActionsSection: some View {
            VStack(spacing: 20) {
                // Main Action - Подать заявку
                Button(action: {
                    print("Application form button tapped")
                    showApplicationForm = true
                }) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 52, height: 52)
                            
                            Image(systemName: "arrow.up.doc.fill") // Более динамичная иконка
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Подать заявку")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Быстро и без регистрации")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color.red, Color.red.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .red.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(ProfessionalButtonStyle())
                
                // Secondary Actions
                HStack(spacing: 12) {
                    SecondaryActionButton(
                        icon: "doc.text.magnifyingglass",
                        title: "Проверить статус",
                        subtitle: "По коду заявки",
                        color: .blue,
                        action: {
                            print("Status check button tapped")
                            showStatusCheck = true
                        }
                    )
                    
                    SecondaryActionButton(
                        icon: "building.2.crop.circle.fill",
                        title: "Университеты",
                        subtitle: "Каталог вузов",
                        color: .purple,
                        action: {
                            print("Universities button tapped")
                            navigateToUniversities = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }

        // MARK: - Tools Section
        private var toolsSection: some View {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Полезные инструменты")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Все необходимое для поступления")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ToolCard(
                        icon: "folder.fill.badge.questionmark", // Более подходящая для документов
                        title: "Документы",
                        description: "Чек-лист и требования",
                        color: .orange,
                        action: {
                            print("Documents button tapped")
                            showDocuments = true
                        }
                    )
                    
                    ToolCard(
                        icon: "clock.badge.exclamationmark.fill", // Более динамичная для сроков
                        title: "Сроки подачи",
                        description: "Важные даты",
                        color: .indigo,
                        action: {
                            print("Deadlines button tapped")
                            showDeadlines = true
                        }
                    )
                    
                    ToolCard(
                        icon: "function", // Более интересная для калькулятора
                        title: "Калькулятор",
                        description: "Шансы поступления",
                        color: .mint,
                        action: {
                            print("Calculator button tapped")
                            showCalculator = true
                        }
                    )
                    
                    ToolCard(
                        icon: "person.fill.questionmark", // Более дружелюбная для помощи
                        title: "Помощь",
                        description: "FAQ и поддержка",
                        color: .teal,
                        action: {
                            print("Help button tapped")
                            showHelp = true
                        }
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 32)
        }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, 40)
            
            VStack(spacing: 12) {
                Text("UniStep — цифровая платформа для приемной кампании")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    FooterLink(title: "Поддержка") {
                        print("Support tapped")
                    }
                    
                    FooterLink(title: "О проекте") {
                        print("About tapped")
                    }
                    
                    FooterLink(title: "Контакты") {
                        print("Contacts tapped")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Supporting Views

struct NotificationButton: View {
    let hasNotification: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                
                Image(systemName: "bell")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if hasNotification {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 10, y: -10)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProfileButton: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 40, height: 40)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
            )
    }
}

struct SecondaryActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(ProfessionalButtonStyle())
    }
}

struct ToolCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(ProfessionalButtonStyle())
    }
}

struct FooterLink: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.red)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Button Styles

struct ProfessionalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
// MARK: - Status Check View
// Модель данных для найденной заявки
struct RealApplicationData {
    let id: String
    let fullName: String
    let university: String
    let faculty: String
    let specialty: String
    let status: String
    let submissionDate: Date
    let phone: String
    let email: String
}

// MARK: - Status Check View (ЗАМЕНИТЬ в HomeView.swift - ЧАСТЬ 1)
struct StatusCheckView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedOption = 0
    @State private var foundApplication: String? = nil
    @State private var foundApplicationData: RealApplicationData? = nil
    @State private var isSearching = false
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        VStack(spacing: 20) {
                            Spacer().frame(height: max(40, geometry.safeAreaInsets.top + 10))
                            
                            // Icon with animation
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(animateContent ? 1 : 0.8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)
                                
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                    .opacity(animateContent ? 1 : 0)
                                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Проверить статус заявки")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.primary)
                                    .opacity(animateContent ? 1 : 0)
                                    .offset(y: animateContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.3), value: animateContent)
                                
                                Text("Введите код заявки или номер телефона для поиска")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .opacity(animateContent ? 1 : 0)
                                    .offset(y: animateContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        
                        // Search Section
                        VStack(spacing: 24) {
                            // Search Type Picker
                            VStack(spacing: 16) {
                                Picker("Тип поиска", selection: $selectedOption) {
                                    Text("По коду заявки").tag(0)
                                    Text("По номеру телефона").tag(1)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .opacity(animateContent ? 1 : 0)
                                .offset(x: animateContent ? 0 : -30)
                                .animation(.easeOut(duration: 0.6).delay(0.5), value: animateContent)
                                .onChange(of: selectedOption) { _ in
                                    searchText = ""
                                    foundApplication = nil
                                    foundApplicationData = nil
                                }
                                
                                // Search Field
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 16) {
                                        Image(systemName: selectedOption == 0 ? "number.circle.fill" : "phone.circle.fill")
                                            .foregroundColor(.blue)
                                            .frame(width: 24)
                                        
                                        TextField(
                                            selectedOption == 0 ? "AB2025-1234" : "+7 777 123 45 67",
                                            text: $searchText
                                        )
                                        .keyboardType(selectedOption == 0 ? .default : .default)
                                        .autocapitalization(selectedOption == 0 ? .allCharacters : .none)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                        .accentColor(.blue)
                                        .onSubmit {
                                            searchApplications()
                                        }
                                        .onChange(of: searchText) { newValue in
                                            if selectedOption == 1 {
                                                // Форматируем телефон во время ввода
                                                let formatted = formatPhoneInput(newValue)
                                                if formatted != newValue {
                                                    searchText = formatted
                                                }
                                            }
                                        }
                                        
                                        if isSearching {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    
                                    // Подсказки по формату
                                    if selectedOption == 0 {
                                        Text("Формат: AB2025-1234")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                    } else {
                                        Text("Формат: +7 777 123 45 67 или 87771234567")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 4)
                                    }
                                }
                                .opacity(animateContent ? 1 : 0)
                                .offset(x: animateContent ? 0 : 30)
                                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
                            }
                            
                            // Search Button
                            Button(action: searchApplications) {
                                HStack(spacing: 12) {
                                    if !isSearching {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    
                                    Text(isSearching ? "Поиск..." : "Найти заявку")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: searchText.isEmpty || isSearching ?
                                                [Color.gray.opacity(0.6)] :
                                                    [Color.blue, Color.blue.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                                .foregroundColor(.white)
                                .shadow(
                                    color: searchText.isEmpty || isSearching ? Color.clear : Color.blue.opacity(0.3),
                                    radius: 8, x: 0, y: 4
                                )
                            }
                            .disabled(searchText.isEmpty || isSearching)
                            .opacity(animateContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateContent)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                        
                        // Results Section
                        if let result = foundApplication {
                            if let appData = foundApplicationData {
                                // Заявка найдена
                                VStack(spacing: 20) {
                                    // Success icon
                                    ZStack {
                                        Circle()
                                            .fill(Color.green.opacity(0.15))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(spacing: 12) {
                                        Text("Заявка найдена")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Text("Заявка успешно найдена в системе")
                                            .font(.system(size: 16))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    // Application card
                                    VStack(spacing: 16) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(appData.university)
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.primary)
                                                
                                                Text(appData.specialty)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            StatusBadge(status: ApplicationStatus(rawValue: appData.status) ?? .pending)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            HStack {
                                                SimpleDetailRow(title: "Абитуриент", value: appData.fullName)
                                                Spacer()
                                                SimpleDetailRow(title: "Дата подачи", value: formatDate(appData.submissionDate))
                                            }
                                            
                                            HStack {
                                                SimpleDetailRow(title: "Факультет", value: appData.faculty)
                                                Spacer()
                                                SimpleDetailRow(title: "Телефон", value: appData.phone)
                                            }
                                            
                                            HStack {
                                                SimpleDetailRow(title: "Email", value: appData.email)
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(20)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                                }
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            } else {
                                // Заявка не найдена
                                VStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red.opacity(0.15))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.red)
                                    }
                                    
                                    VStack(spacing: 12) {
                                        Text("Заявка не найдена")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Text("Проверьте правильность введенных данных и попробуйте еще раз")
                                            .font(.system(size: 16))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        
                        Spacer().frame(height: max(40, geometry.safeAreaInsets.bottom + 20))
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .onAppear {
                withAnimation {
                    animateContent = true
                }
            }
            .navigationTitle("Статус заявки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - ЧАСТЬ 2: Функции поиска (добавить после body: some View)
    
    // MARK: - Phone Formatting Function
    private func formatPhoneInput(_ input: String) -> String {
        // Удаляем все нецифровые символы кроме +
        let digits = input.filter { $0.isNumber || $0 == "+" }
        
        // Если начинается с 8, заменяем на +7
        if digits.hasPrefix("8") {
            let withoutFirst = String(digits.dropFirst())
            return "+7" + withoutFirst
        }
        
        // Если начинается с 7 (без +), добавляем +
        if digits.hasPrefix("7") && !digits.hasPrefix("+7") {
            return "+" + digits
        }
        
        return digits
    }
    
    
    // MARK: - Enhanced Search Function
    private func searchApplications() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        isSearching = true
        foundApplication = nil
        foundApplicationData = nil
        
        let db = Firestore.firestore()
        
        print("🔍 Начинаем поиск заявки...")
        print("🔍 Поисковый запрос: '\(searchText)'")
        print("🔍 Тип поиска: \(selectedOption == 0 ? "По коду" : "По телефону")")
        
        if selectedOption == 0 {
            // Поиск по ID заявки - улучшенный поиск
            searchByApplicationId()
        } else {
            // Поиск по телефону - улучшенный поиск
            searchByPhoneNumber()
        }
    }
    
    private func searchByApplicationId() {
        let db = Firestore.firestore()
        let searchId = searchText.trimmingCharacters(in: .whitespaces)
        
        // Сначала пробуем найти по точному ID документа
        db.collection("applications").document(searchId).getDocument { snapshot, error in
            if let document = snapshot, document.exists {
                self.processFoundDocument(document)
                return
            }
            
            // Если не найдено, ищем в поле id внутри документов
            db.collection("applications")
                .whereField("id", isEqualTo: searchId)
                .getDocuments { snapshot, error in
                    self.handleSearchResults(snapshot: snapshot, error: error, searchTerm: searchId)
                }
        }
    }
    
    private func searchByPhoneNumber() {
        let db = Firestore.firestore()
        let searchPhone = searchText.trimmingCharacters(in: .whitespaces)
        
        // Создаем массив возможных форматов телефона
        let phoneFormats = generatePhoneFormats(from: searchPhone)
        
        print("🔍 Ищем по форматам телефона: \(phoneFormats)")
        
        // Ищем по всем возможным форматам
        db.collection("applications")
            .whereField("phone", in: phoneFormats)
            .getDocuments { snapshot, error in
                self.handleSearchResults(snapshot: snapshot, error: error, searchTerm: searchPhone)
            }
    }
    
    private func generatePhoneFormats(from input: String) -> [String] {
        let cleanDigits = input.filter { $0.isNumber }
        var formats: [String] = [input] // Оригинальный ввод
        
        if cleanDigits.count >= 10 {
            let last10 = String(cleanDigits.suffix(10))
            let last11 = cleanDigits.count >= 11 ? String(cleanDigits.suffix(11)) : ""
            
            // Различные форматы
            formats.append("+7" + last10)
            formats.append("8" + last10)
            formats.append("+7 " + formatWithSpaces(last10))
            formats.append("8 " + formatWithSpaces(last10))
            formats.append("+7 (" + String(last10.prefix(3)) + ") " + formatMiddlePart(last10))
            formats.append("8 (" + String(last10.prefix(3)) + ") " + formatMiddlePart(last10))
            
            if !last11.isEmpty {
                formats.append(last11)
                formats.append("+" + last11)
            }
        }
        
        return Array(Set(formats)) // Убираем дубликаты
    }
    
    private func formatWithSpaces(_ digits: String) -> String {
        guard digits.count == 10 else { return digits }
        let formatted = String(digits.prefix(3)) + " " +
        String(digits.dropFirst(3).prefix(3)) + " " +
        String(digits.dropFirst(6).prefix(2)) + " " +
        String(digits.suffix(2))
        return formatted
    }
    
    private func formatMiddlePart(_ digits: String) -> String {
        guard digits.count == 10 else { return digits }
        return String(digits.dropFirst(3).prefix(3)) + "-" +
        String(digits.dropFirst(6).prefix(2)) + "-" +
        String(digits.suffix(2))
    }
    
    private func handleSearchResults(snapshot: QuerySnapshot?, error: Error?, searchTerm: String) {
        DispatchQueue.main.async {
            self.isSearching = false
            
            if let error = error {
                print("❌ Ошибка поиска: \(error)")
                self.foundApplication = "Ошибка поиска"
                self.foundApplicationData = nil
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("📝 Заявка не найдена для: \(searchTerm)")
                self.foundApplication = "Заявка не найдена"
                self.foundApplicationData = nil
                return
            }
            
            // Берем первую найденную заявку
            self.processFoundDocument(documents[0])
        }
    }
    
    private func processFoundDocument(_ document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        
        DispatchQueue.main.async {
            self.isSearching = false
            
            self.foundApplicationData = RealApplicationData(
                id: document.documentID,
                fullName: data["fullName"] as? String ?? "",
                university: data["university"] as? String ?? "",
                faculty: data["faculty"] as? String ?? "",
                specialty: data["specialty"] as? String ?? "",
                status: data["status"] as? String ?? "pending",
                submissionDate: (data["submissionDate"] as? Timestamp)?.dateValue() ?? Date(),
                phone: data["phone"] as? String ?? "",
                email: data["email"] as? String ?? ""
            )
            
            self.foundApplication = "Заявка найдена"
            print("✅ Найдена заявка для: \(self.foundApplicationData?.fullName ?? "")")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    // MARK: - Simple Detail Row (если его нет)
    struct SimpleDetailRow: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
        }
    }
    
    // MARK: - Supporting Views
    
    struct ApplicationResultCard: View {
        let application: Application
        
        var body: some View {
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(application.universityShortName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(application.faculty)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: application.status)
                }
                
                // Details
                VStack(spacing: 8) {
                    HStack {
                        DetailRow(
                            title: "Абитуриент",
                            value: application.fullName,
                            icon: "person.fill"
                        )
                        
                        Spacer()
                        
                        DetailRow(
                            title: "Подана",
                            value: formatDate(application.submissionDate),
                            icon: "calendar"
                        )
                    }
                    
                    if !application.specialization.isEmpty {
                        HStack {
                            DetailRow(
                                title: "Специальность",
                                value: application.specialization,
                                icon: "book.fill"
                            )
                            
                            Spacer()
                        }
                    }
                }
                
                // Action
                HStack {
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Подробнее")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        }
    }
    
    struct SuggestionRow: View {
        let text: String
        
        var body: some View {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 4, height: 4)
                
                Text(text)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
    struct InfoSection<Content: View>: View {
        let title: String
        let content: Content
        
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    content
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Placeholder Views для недостающих экранов

// Заглушки для views если они не существуют
struct DocumentsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var checkedDocuments: Set<Int> = []
    
    let requiredDocuments = [
        DocumentItem(
            id: 0,
            title: "Документ, удостоверяющий личность",
            description: "Паспорт или удостоверение личности",
            isRequired: true,
            note: "Оригинал + копия"
        ),
        DocumentItem(
            id: 1,
            title: "Документ об образовании",
            description: "Аттестат о среднем образовании",
            isRequired: true,
            note: "Оригинал + нотариальная копия"
        ),
        DocumentItem(
            id: 2,
            title: "Результаты ЕНТ/КТА",
            description: "Сертификат о прохождении тестирования",
            isRequired: true,
            note: "Действителен в текущем году"
        ),
        DocumentItem(
            id: 3,
            title: "Фотографии",
            description: "6 фотографий размером 3x4 см",
            isRequired: true,
            note: "Цветные, на белом фоне"
        ),
        DocumentItem(
            id: 4,
            title: "Медицинская справка",
            description: "Справка формы 086-У",
            isRequired: true,
            note: "Действительна 6 месяцев"
        ),
        DocumentItem(
            id: 5,
            title: "Военный билет",
            description: "Для лиц мужского пола",
            isRequired: false,
            note: "При наличии"
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "folder.fill.badge.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        VStack(spacing: 8) {
                            Text("Необходимые документы")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Проверьте наличие всех документов для поступления")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Progress
                    VStack(spacing: 12) {
                        HStack {
                            Text("Прогресс подготовки")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(checkedDocuments.count)/\(requiredDocuments.filter(\.isRequired).count)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                        
                        ProgressView(value: Double(checkedDocuments.count), total: Double(requiredDocuments.filter(\.isRequired).count))
                            .tint(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Documents List
                    VStack(spacing: 16) {
                        ForEach(requiredDocuments, id: \.id) { document in
                            DocumentCheckCard(
                                document: document,
                                isChecked: checkedDocuments.contains(document.id)
                            ) {
                                toggleDocument(document.id)
                            }
                        }
                    }
                    
                    // Tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 Полезные советы")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 8) {
                            TipRow(text: "Подготовьте документы заранее - за 2-3 недели до подачи")
                            TipRow(text: "Сделайте копии всех документов")
                            TipRow(text: "Проверьте сроки действия справок")
                            TipRow(text: "Уточните требования конкретного университета")
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Документы")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
    
    private func toggleDocument(_ id: Int) {
        if checkedDocuments.contains(id) {
            checkedDocuments.remove(id)
        } else {
            checkedDocuments.insert(id)
        }
    }
}

struct DocumentItem {
    let id: Int
    let title: String
    let description: String
    let isRequired: Bool
    let note: String
}

struct DocumentCheckCard: View {
    let document: DocumentItem
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Checkbox
                ZStack {
                    Circle()
                        .fill(isChecked ? Color.orange : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(isChecked ? Color.orange : Color.gray, lineWidth: 2)
                        )
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(document.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        if document.isRequired {
                            Text("*")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    
                    Text(document.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text(document.note)
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.blue)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct DeadlinesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    let keyDates = [
        DeadlineItem(
            date: Date.from("2025-06-20"),
            title: "Начало приема документов",
            description: "Открытие приемной кампании",
            type: .start,
            isImportant: true
        ),
        DeadlineItem(
            date: Date.from("2025-07-25"),
            title: "Окончание приема документов",
            description: "Последний день подачи на государственный грант",
            type: .deadline,
            isImportant: true
        ),
        DeadlineItem(
            date: Date.from("2025-08-05"),
            title: "Окончание приема на платное",
            description: "Последний день для платного обучения",
            type: .deadline,
            isImportant: false
        ),
        DeadlineItem(
            date: Date.from("2025-08-10"),
            title: "Объявление результатов",
            description: "Публикация списков поступивших",
            type: .result,
            isImportant: true
        ),
        DeadlineItem(
            date: Date.from("2025-08-15"),
            title: "Подтверждение поступления",
            description: "Последний день для подтверждения",
            type: .confirmation,
            isImportant: true
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.exclamationmark.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.indigo)
                    
                    VStack(spacing: 8) {
                        Text("Важные даты")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Не пропустите сроки приемной кампании 2025")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                // Current Status
                currentStatusCard
                    .padding()
                
                // Tabs
                Picker("", selection: $selectedTab) {
                    Text("Календарь").tag(0)
                    Text("Этапы").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Content
                if selectedTab == 0 {
                    calendarView
                } else {
                    stagesView
                }
                
                Spacer()
            }
            .navigationTitle("Сроки подачи")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
    
    private var currentStatusCard: some View {
        let nextDeadline = keyDates.first { $0.date > Date() }
        
        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Текущий статус")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if let next = nextDeadline {
                        Text("До \(next.title.lowercased())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Приемная кампания завершена")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                if let next = nextDeadline {
                    VStack(alignment: .trailing) {
                        Text("\(daysUntil(next.date)) дней")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                        
                        Text("осталось")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.indigo.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var calendarView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(keyDates.sorted { $0.date < $1.date }, id: \.title) { deadline in
                    DeadlineCard(deadline: deadline)
                }
            }
            .padding()
        }
    }
    
    private var stagesView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(keyDates.sorted { $0.date < $1.date }.enumerated()), id: \.element.title) { index, deadline in
                    StageRow(
                        deadline: deadline,
                        isLast: index == keyDates.count - 1,
                        isCompleted: deadline.date < Date()
                    )
                }
            }
            .padding()
        }
    }
    
    private func daysUntil(_ date: Date) -> Int {
        max(0, Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0)
    }
}

struct DeadlineItem {
    let date: Date
    let title: String
    let description: String
    let type: DeadlineType
    let isImportant: Bool
}

enum DeadlineType {
    case start, deadline, result, confirmation
    
    var color: Color {
        switch self {
        case .start: return .green
        case .deadline: return .red
        case .result: return .blue
        case .confirmation: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .start: return "play.circle.fill"
        case .deadline: return "exclamationmark.triangle.fill"
        case .result: return "list.bullet.clipboard.fill"
        case .confirmation: return "checkmark.circle.fill"
        }
    }
}

struct DeadlineCard: View {
    let deadline: DeadlineItem
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text(DateFormatter.day.string(from: deadline.date))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(deadline.type.color)
                
                Text(DateFormatter.monthShort.string(from: deadline.date).uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(deadline.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if deadline.isImportant {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                }
                
                Text(deadline.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                Text("Осталось: \(daysUntil(deadline.date)) дней")
                    .font(.system(size: 12))
                    .foregroundColor(deadline.type.color)
            }
            
            Image(systemName: deadline.type.icon)
                .font(.system(size: 20))
                .foregroundColor(deadline.type.color)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func daysUntil(_ date: Date) -> Int {
        max(0, Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0)
    }
}

struct StageRow: View {
    let deadline: DeadlineItem
    let isLast: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? deadline.type.color : Color.gray.opacity(0.3))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: isCompleted ? "checkmark" : deadline.type.icon)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(deadline.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(deadline.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                Text(DateFormatter.full.string(from: deadline.date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(deadline.type.color)
            }
            
            Spacer()
        }
        .padding(.bottom, isLast ? 0 : 16)
    }
}

extension DateFormatter {
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    static let monthShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}

extension Date {
    static func from(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string) ?? Date()
    }
}


// MARK: - University Picker

struct UniversityPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let universities: [String]
    @Binding var selectedUniversity: String
    
    var body: some View {
        NavigationView {
            List(universities, id: \.self) { university in
                Button(action: {
                    selectedUniversity = university
                    dismiss()
                }) {
                    HStack {
                        Text(university)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if selectedUniversity == university {
                            Image(systemName: "checkmark")
                                .foregroundColor(.mint)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Выберите университет")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Specialty Picker

struct SpecialtyPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let specialties: [String]
    @Binding var selectedSpecialty: String
    
    var body: some View {
        NavigationView {
            List(specialties, id: \.self) { specialty in
                Button(action: {
                    selectedSpecialty = specialty
                    dismiss()
                }) {
                    HStack {
                        Text(specialty)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if selectedSpecialty == specialty {
                            Image(systemName: "checkmark")
                                .foregroundColor(.mint)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Выберите специальность")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { dismiss() }
                }
            }
        }
    }
}

struct CalculationResult {
    let percentage: Int
    let level: String
    let recommendation: String
    let entScore: Int
    let certScore: Double
    let university: String
    let specialty: String
}

struct ScoreInputCard: View {
    let title: String
    let placeholder: String
    @Binding var value: String
    let maxValue: Double
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $value)
                .keyboardType(.decimalPad)
                .font(.system(size: 16))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            HStack {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let numValue = Double(value), numValue > 0 {
                    Text("\(Int((numValue / maxValue) * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.mint)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct SelectionCard: View {
    let title: String
    let value: String
    let placeholder: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Button(action: action) {
                HStack {
                    Text(value.isEmpty ? placeholder : value)
                        .font(.system(size: 16))
                        .foregroundColor(value.isEmpty ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ResultCard: View {
    let result: CalculationResult
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("📈 Результат расчета")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Ваши шансы на поступление")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Main Result
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(result.percentage) / 100)
                        .stroke(
                            LinearGradient(
                                colors: [.mint, .green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(result.percentage)%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.mint)
                        
                        Text(result.level)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(result.recommendation)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Details
            VStack(spacing: 12) {
                DetailResultRow(title: "Балл ЕНТ", value: "\(result.entScore)")
                DetailResultRow(title: "Средний балл", value: String(format: "%.1f", result.certScore))
                DetailResultRow(title: "Университет", value: result.university)
                if !result.specialty.isEmpty {
                    DetailResultRow(title: "Специальность", value: result.specialty)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct DetailResultRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct TipItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.mint)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.teal)
                
                Text("Помощь")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Часто задаваемые вопросы и поддержка")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Помощь")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}

struct CalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var entScore: String = ""
    @State private var certificateScore: String = ""
    @State private var selectedUniversity = ""
    @State private var selectedSpecialty = ""
    @State private var calculateResult: CalculationResult?
    @State private var showUniversityPicker = false
    @State private var showSpecialtyPicker = false
    
    // Используем данные из University.swift
    var universities: [String] {
        return University.getCalculatorUniversityNames()
    }
    
    var specialties: [String] {
        return University.getAllSpecialtyNames()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "function")
                            .font(.system(size: 60))
                            .foregroundColor(.mint)
                        
                        VStack(spacing: 8) {
                            Text("Калькулятор шансов")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Оцените свои шансы на поступление")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Input Form
                    VStack(spacing: 20) {
                        // Scores Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("📊 Ваши баллы")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            ScoreInputCard(
                                title: "Балл ЕНТ/КТА",
                                placeholder: "125",
                                value: $entScore,
                                maxValue: 140,
                                description: "Максимум: 140 баллов"
                            )
                            
                            ScoreInputCard(
                                title: "Средний балл аттестата",
                                placeholder: "4.5",
                                value: $certificateScore,
                                maxValue: 5,
                                description: "По 5-балльной шкале"
                            )
                        }
                        
                        // University Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("🎓 Выбор направления")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            VStack(spacing: 12) {
                                SelectionCard(
                                    title: "Университет",
                                    value: selectedUniversity,
                                    placeholder: "Выберите университет"
                                ) {
                                    showUniversityPicker = true
                                }
                                
                                SelectionCard(
                                    title: "Специальность",
                                    value: selectedSpecialty,
                                    placeholder: "Выберите специальность"
                                ) {
                                    showSpecialtyPicker = true
                                }
                            }
                        }
                        
                        // Calculate Button
                        Button(action: calculateChances) {
                            HStack(spacing: 12) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Рассчитать шансы")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: canCalculate ? [Color.mint, Color.mint.opacity(0.8)] : [Color.gray.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(
                                color: canCalculate ? Color.mint.opacity(0.3) : Color.clear,
                                radius: 8, x: 0, y: 4
                            )
                        }
                        .disabled(!canCalculate)
                    }
                    
                    // Results
                    if let result = calculateResult {
                        ResultCard(result: result)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // Tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 Как повысить шансы")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 8) {
                            TipItem(text: "Подайте документы в несколько университетов")
                            TipItem(text: "Рассмотрите альтернативные специальности")
                            TipItem(text: "Участвуйте в олимпиадах для получения льгот")
                            TipItem(text: "Подготовьтесь к повторной сдаче ЕНТ")
                        }
                    }
                    .padding()
                    .background(Color.mint.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Калькулятор")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
            // Picker для университетов
            .sheet(isPresented: $showUniversityPicker) {
                UniversityPickerView(
                    universities: universities,
                    selectedUniversity: $selectedUniversity
                )
            }
            // Picker для специальностей
            .sheet(isPresented: $showSpecialtyPicker) {
                SpecialtyPickerView(
                    specialties: specialties,
                    selectedSpecialty: $selectedSpecialty
                )
            }
        }
    }
    
    private var canCalculate: Bool {
        !entScore.isEmpty && !certificateScore.isEmpty && !selectedUniversity.isEmpty
    }
    
    // MARK: - РАСЧЕТ С МАТЕМАТИЧЕСКОЙ ФОРМУЛОЙ + ОТЛАДКА
    
    private func calculateChances() {
        print("🚀 Кнопка 'Рассчитать шансы' нажата")
        print("entScore: '\(entScore)', certificateScore: '\(certificateScore)'")
        print("selectedUniversity: '\(selectedUniversity)', selectedSpecialty: '\(selectedSpecialty)'")
        
        guard let entScoreValue = Double(entScore),
              let certScoreValue = Double(certificateScore) else {
            print("❌ Ошибка: не удается преобразовать баллы в числа")
            
            // Тестовый результат для проверки
            calculateResult = CalculationResult(
                percentage: 75,
                level: "Тестовые данные",
                recommendation: "Тест: проблема с преобразованием баллов",
                entScore: 0,
                certScore: 0.0,
                university: selectedUniversity,
                specialty: selectedSpecialty
            )
            return
        }
        
        print("✅ Баллы корректны: ЕНТ \(entScoreValue), Аттестат \(certScoreValue)")
        calculateAdvancedChances()
    }
    
    private func calculateAdvancedChances() {
        guard let entScoreValue = Double(entScore),
              let certScoreValue = Double(certificateScore) else {
            print("❌ Ошибка в calculateAdvancedChances")
            return
        }
        
        print("🔍 Начинаем расчет с реальными данными...")
        
        // 1. Рассчитываем общий балл абитуриента
        let applicantScore = entScoreValue + (certScoreValue * 4)
        print("Общий балл: \(applicantScore)")
        
        // 2. Ищем информацию о выбранной специальности
        print("Ищем: '\(selectedSpecialty)' в '\(selectedUniversity)'")
        
        let specialtyInfo = University.getSpecialty(
            university: selectedUniversity,
            specialty: selectedSpecialty
        )
        
        if let info = specialtyInfo {
            print("✅ Специальность найдена!")
            print("Название: \(info.name)")
            print("Мин. балл на грант: \(info.minGrantScore)")
            print("Мин. балл на платное: \(info.minPaidScore)")
            
            // 3. Рассчитываем шансы на грант МАТЕМАТИЧЕСКОЙ ФОРМУЛОЙ
            let grantChance = calculateGrantChance(
                applicantScore: applicantScore,
                minGrantScore: Double(info.minGrantScore)
            )
            
            // 4. Рассчитываем шансы на платное МАТЕМАТИЧЕСКОЙ ФОРМУЛОЙ
            let paidChance = calculatePaidChance(
                applicantScore: applicantScore,
                minPaidScore: Double(info.minPaidScore)
            )
            
            // 5. Определяем финальный результат
            let (percentage, level, recommendation) = determineAdvancedChances(
                grantChance: grantChance,
                paidChance: paidChance,
                specialtyInfo: info
            )
            
            print("Финальный результат: \(percentage)% - \(level)")
            
            calculateResult = CalculationResult(
                percentage: percentage,
                level: level,
                recommendation: recommendation,
                entScore: Int(entScoreValue),
                certScore: certScoreValue,
                university: selectedUniversity,
                specialty: selectedSpecialty
            )
            print("✅ Результат установлен!")
            
        } else {
            print("❌ Специальность НЕ найдена, переходим к fallback")
            calculateFallbackChances()
        }
    }
    
    // MARK: - МАТЕМАТИЧЕСКИЕ ФОРМУЛЫ ДЛЯ ГРАНТА
    
    private func calculateGrantChance(applicantScore: Double, minGrantScore: Double) -> Int {
        let difference = applicantScore - minGrantScore
        print("Разность для гранта: \(difference)")
        
        let percentage: Double
        
        if difference >= 20 {
            percentage = 95.0
        } else if difference >= 0 {
            // Линейная интерполяция между 35% и 95%
            percentage = 35.0 + (difference / 20.0) * 60.0
        } else if difference >= -10 {
            // Экспоненциальное снижение для отрицательных значений
            percentage = 35.0 * exp(difference / 10.0)
        } else {
            percentage = 1.0
        }
        
        let result = max(1, min(99, Int(percentage.rounded())))
        print("Шанс на грант: \(result)%")
        return result
    }
    
    private func calculatePaidChance(applicantScore: Double, minPaidScore: Double) -> Int {
        let difference = applicantScore - minPaidScore
        print("Разность для платного: \(difference)")
        
        let percentage: Double
        
        if difference >= 15 {
            percentage = 97.0
        } else if difference >= 0 {
            // Линейная интерполяция между 60% и 97%
            percentage = 60.0 + (difference / 15.0) * 37.0
        } else if difference >= -8 {
            // Экспоненциальное снижение (более мягкое для платного)
            percentage = 60.0 * exp(difference / 8.0)
        } else {
            percentage = 5.0
        }
        
        let result = max(5, min(99, Int(percentage.rounded())))
        print("Шанс на платное: \(result)%")
        return result
    }
    
    private func determineAdvancedChances(grantChance: Int, paidChance: Int, specialtyInfo: SpecialtyInfo) -> (Int, String, String) {
        print("Определяем результат: грант \(grantChance)%, платное \(paidChance)%")
        
        let percentage: Int
        let level: String
        let recommendation: String
        
        if grantChance >= 70 {
            percentage = grantChance
            level = "Высокие шансы на грант"
            recommendation = "🎉 Отличные результаты! У вас \(grantChance)% шансов получить грант на \"\(specialtyInfo.name)\". Проходной балл на грант: \(specialtyInfo.minGrantScore)."
            
        } else if grantChance >= 40 {
            percentage = grantChance
            level = "Средние шансы на грант"
            recommendation = "📊 Средние шансы на грант (\(grantChance)%). Проходной балл: \(specialtyInfo.minGrantScore). Рассмотрите также платное обучение (\(paidChance)% шансов, мин. балл: \(specialtyInfo.minPaidScore))."
            
        } else if paidChance >= 60 {
            percentage = paidChance
            level = "Хорошие шансы на платное"
            recommendation = "💰 Шансы на грант низкие (\(grantChance)%), но высокие шансы на платное обучение (\(paidChance)%). Мин. балл для платного: \(specialtyInfo.minPaidScore)."
            
        } else if paidChance >= 30 {
            percentage = paidChance
            level = "Средние шансы на платное"
            recommendation = "🤔 Средние шансы на платное обучение (\(paidChance)%). Грант: \(grantChance)%. Рекомендуем рассмотреть менее конкурентные специальности."
            
        } else {
            percentage = max(grantChance, paidChance)
            level = "Низкие шансы"
            recommendation = "📚 Низкие шансы на поступление. Грант: \(grantChance)%, платное: \(paidChance)%. Мин. балл для гранта: \(specialtyInfo.minGrantScore), для платного: \(specialtyInfo.minPaidScore). Рекомендуем дополнительную подготовку."
        }
        
        return (percentage, level, recommendation)
    }
    
    // MARK: - Резервная функция для специальностей не в базе данных
    
    private func calculateFallbackChances() {
        print("🔄 Используем резервную логику")
        
        guard let entScoreValue = Double(entScore),
              let certScoreValue = Double(certificateScore) else {
            print("❌ Ошибка в fallback")
            return
        }
        
        // Используем старую логику для неизвестных специальностей
        let baseScore = calculateBaseScore(ent: entScoreValue, certificate: certScoreValue)
        let universityMultiplier = getUniversityMultiplier(university: selectedUniversity)
        let specialtyMultiplier = getSpecialtyMultiplier(specialty: selectedSpecialty)
        let finalScore = baseScore * universityMultiplier * specialtyMultiplier
        
        print("Fallback расчет: base=\(baseScore), uni=\(universityMultiplier), spec=\(specialtyMultiplier), final=\(finalScore)")
        
        let (percentage, level, recommendation) = determineChances(score: finalScore,
                                                                 university: selectedUniversity,
                                                                 specialty: selectedSpecialty)
        
        calculateResult = CalculationResult(
            percentage: percentage,
            level: level,
            recommendation: recommendation,
            entScore: Int(entScoreValue),
            certScore: certScoreValue,
            university: selectedUniversity,
            specialty: selectedSpecialty
        )
        
        print("✅ Fallback результат: \(percentage)% - \(level)")
    }
    
    // MARK: - Старые вспомогательные функции (для резерва)
    
    private func calculateBaseScore(ent: Double, certificate: Double) -> Double {
        let entWeight = 0.7
        let certificateWeight = 0.3
        let normalizedENT = (ent / 140.0) * 100.0
        let normalizedCertificate = (certificate / 5.0) * 100.0
        return normalizedENT * entWeight + normalizedCertificate * certificateWeight
    }

    private func getUniversityMultiplier(university: String) -> Double {
        let universityDifficulty: [String: Double] = [
            "НУ": 0.6, "КИМЭП": 0.65, "КазНУ": 0.7, "КазНМУ": 0.7, "КБТУ": 0.75,
            "МУИТ": 0.78, "КазНТУ": 0.8, "КазГЮУ": 0.8, "КазНПУ": 0.85
        ]
        return universityDifficulty[university] ?? 0.8
    }

    private func getSpecialtyMultiplier(specialty: String) -> Double {
        let specialtyDifficulty: [String: Double] = [
            "Медицина": 0.5, "Информационные системы": 0.6, "Программная инженерия": 0.65,
            "Экономика": 0.7, "Юриспруденция": 0.75, "Менеджмент": 0.8,
            "Инженерия": 0.85, "Педагогика": 0.9
        ]
        return specialtyDifficulty[specialty] ?? 0.8
    }

    private func determineChances(score: Double, university: String, specialty: String) -> (Int, String, String) {
        let percentage: Int
        let level: String
        let recommendation: String
        
        switch score {
        case 85...:
            percentage = 94
            level = "Очень высокие шансы"
            recommendation = "Превосходные результаты! Вы практически гарантированно поступите."
        case 75..<85:
            percentage = 82
            level = "Высокие шансы"
            recommendation = "Отличные результаты! У вас высокие шансы на поступление в \(university)."
        case 65..<75:
            percentage = 67
            level = "Хорошие шансы"
            recommendation = "Хорошие результаты. Рекомендуем подать документы в 2-3 университета."
        case 50..<65:
            percentage = 50
            level = "Средние шансы"
            recommendation = "Средние результаты. Рассмотрите менее популярные специальности."
        case 35..<50:
            percentage = 30
            level = "Низкие шансы"
            recommendation = "Рассмотрите менее престижные университеты."
        default:
            percentage = 12
            level = "Очень низкие шансы"
            recommendation = "Рекомендуем дополнительную подготовку и повторную сдачу ЕНТ."
        }
        
        return (percentage, level, recommendation)
    }
}

#Preview {
    HomeView()
}


