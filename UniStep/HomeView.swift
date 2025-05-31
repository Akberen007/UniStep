
//
//  HomeView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

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
            }
            // Навигация
            .navigationDestination(isPresented: $navigateToUniversities) {
                UniversitiesCatalogView()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
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
                            Image(systemName: "graduationcap.fill")
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
                    print("Profile tapped")
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
                        
                        Image(systemName: "doc.fill")
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
                    icon: "magnifyingglass.circle.fill",
                    title: "Проверить статус",
                    subtitle: "По коду заявки",
                    color: .blue,
                    action: {
                        print("Status check button tapped")
                        showStatusCheck = true
                    }
                )
                
                SecondaryActionButton(
                    icon: "building.2.circle.fill",
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
                    icon: "doc.text.fill",
                    title: "Документы",
                    description: "Чек-лист и требования",
                    color: .orange,
                    action: {
                        print("Documents button tapped")
                        showDocuments = true
                    }
                )
                
                ToolCard(
                    icon: "calendar.badge.clock",
                    title: "Сроки подачи",
                    description: "Важные даты",
                    color: .indigo,
                    action: {
                        print("Deadlines button tapped")
                        showDeadlines = true
                    }
                )
                
                ToolCard(
                    icon: "calculator",
                    title: "Калькулятор",
                    description: "Шансы поступления",
                    color: .mint,
                    action: {
                        print("Calculator button tapped")
                        showCalculator = true
                    }
                )
                
                ToolCard(
                    icon: "questionmark.circle.fill",
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
struct StatusCheckView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedOption = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Проверить статус заявки")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Введите код заявки или номер телефона")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                VStack(spacing: 20) {
                    Picker("Тип поиска", selection: $selectedOption) {
                        Text("По коду заявки").tag(0)
                        Text("По телефону").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    CustomTextField(
                        title: selectedOption == 0 ? "AB2024-1234" : "+7 (777) 123-45-67",
                        text: $searchText,
                        systemImage: selectedOption == 0 ? "number.circle" : "phone.circle"
                    )
                }
                
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Text("Найти заявку")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(searchText.isEmpty ? Color.gray.opacity(0.6) : Color.blue)
                    )
                    .foregroundColor(.white)
                }
                .disabled(searchText.isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
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
}

// MARK: - Placeholder Views для недостающих экранов

// Заглушки для views если они не существуют
struct DocumentsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Документы")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Список необходимых документов для поступления")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Документы")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}

struct DeadlinesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 60))
                    .foregroundColor(.indigo)
                
                Text("Сроки подачи")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Важные даты приемной кампании")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Сроки")
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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "calculator")
                    .font(.system(size: 60))
                    .foregroundColor(.mint)
                
                Text("Калькулятор")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Рассчитайте свои шансы на поступление")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Калькулятор")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
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

#Preview {
    HomeView()
}
