//
//  HomeView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToDemo = false
    @State private var showContent = false
    @State private var showApplicationForm = false
    @State private var showStatusCheck = false
    @State private var animateCards = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // 🔹 Header
                        headerSection
                        
                        // 🔹 Hero Section
                        heroSection
                        
                        // 🔹 Main Actions
                        mainActionsSection
                            .opacity(animateCards ? 1 : 0)
                            .offset(x: animateCards ? 0 : -50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: animateCards)
                        
                        // 🔹 Features Section
                        featuresSection
                            .opacity(animateCards ? 1 : 0)
                            .offset(x: animateCards ? 0 : 50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: animateCards)
                        
                        // 🔹 Footer
                        footerSection
                    }
                    .padding(.bottom, max(20, geometry.safeAreaInsets.bottom))
                }
                .scrollIndicators(.hidden)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color.uniBackground,
                        Color.uniBackground.opacity(0.8),
                        Color.white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .onAppear {
                // Последовательная анимация появления
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    showContent = true
                }
                
                // Анимация карточек с задержкой
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        animateCards = true
                    }
                }
            }
            .sheet(isPresented: $showApplicationForm) {
                ApplicationFormView()
            }
            .sheet(isPresented: $showStatusCheck) {
                StatusCheckView()
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
                        .frame(width: 50, height: 50)
                    
                    Image("books1")
                        .resizable()
                        .frame(width: 28, height: 32)
                        .foregroundColor(.red)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("UniStep")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Приемная кампания")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Уведомления
                Button(action: {
                    // TODO: Уведомления
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                        
                        // Красная точка
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 12, y: -12)
                    }
                }
                
                // Профиль
                NavigationLink(destination: LoginView()) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.red)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : -30)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: showContent)
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Улучшенный SlideView с привлекательным контентом
            SlideView()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16)) // Уменьшил с 20 до 16
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.9)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: showContent)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Main Actions Section
    private var mainActionsSection: some View {
        VStack(spacing: 20) {
            // Заголовок секции
            HStack {
                Text("Основные действия")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                // Подать заявку - Главная кнопка
                PrimaryActionCard(
                    icon: "doc.fill",
                    title: "Подать заявку",
                    subtitle: "Быстро и без регистрации",
                    gradient: LinearGradient(
                        colors: [Color.red, Color.red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    action: {
                        showApplicationForm = true
                    }
                )
                
                // Вторичные действия - одинакового размера
                HStack(spacing: 12) {
                    MediumActionCard(
                        icon: "magnifyingglass.circle.fill",
                        title: "Проверить статус",
                        subtitle: "По номеру",
                        gradient: LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        action: {
                            showStatusCheck = true
                        }
                    )
                    .frame(height: 100) // Фиксированная высота
                    
                    MediumActionCard(
                        icon: "building.2.circle.fill",
                        title: "Университеты",
                        subtitle: "Выбрать вуз",
                        gradient: LinearGradient(
                            colors: [Color.purple, Color.purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        action: {
                            // TODO: Показать список университетов
                        }
                    )
                    .frame(height: 100) // Фиксированная высота
                }
                
                // Дополнительные действия в одну строку - исправленная версия
                HStack(spacing: 8) {
                    CompactActionButton(
                        icon: "doc.text.fill",
                        title: "Документы",
                        color: .orange,
                        action: {
                            // TODO: Список документов
                        }
                    )
                    
                    CompactActionButton(
                        icon: "calendar.badge.clock",
                        title: "Сроки подачи",
                        color: .indigo,
                        action: {
                            // TODO: Календарь сроков
                        }
                    )
                    
                    CompactActionButton(
                        icon: "calculator",
                        title: "Калькулятор",
                        color: .mint,
                        action: {
                            // TODO: Калькулятор баллов
                        }
                    )
                    
                    CompactActionButton(
                        icon: "questionmark.circle",
                        title: "Помощь",
                        color: .teal,
                        action: {
                            // TODO: FAQ
                        }
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Возможности UniStep")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                ModernFeatureItem(
                    icon: "bolt.fill",
                    text: "Автоматизация заявок",
                    description: "Подача документов за несколько минут",
                    color: .orange
                )
                
                ModernFeatureItem(
                    icon: "doc.fill",
                    text: "Цифровые документы",
                    description: "Загрузка и хранение файлов в облаке",
                    color: .blue
                )
                
                ModernFeatureItem(
                    icon: "chart.bar.fill",
                    text: "Отслеживание в реальном времени",
                    description: "Мгновенные уведомления о статусе",
                    color: .green
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 16) // Изменил с 24 на 16
                .fill(Color.gray.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, 40)
            
            VStack(spacing: 16) {
                Text("UniStep — платформа для цифровизации приёмной кампании")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 24) {
                    Button("Поддержка") {
                        // TODO: Поддержка
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
                    
                    Button("О проекте") {
                        // TODO: О проекте
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
                    
                    Button("Контакты") {
                        // TODO: Контакты
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 32)
    }
}

// MARK: - Primary Action Card
struct PrimaryActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 58, height: 58)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 22)
            .background(gradient)
            .cornerRadius(16) // Уменьшил с 22 до 16
            .shadow(color: .red.opacity(0.4), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(BounceButtonStyle())
    }
}

// MARK: - Medium Action Card (одинаковые размеры)
struct MediumActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(gradient)
            .cornerRadius(16) // Уменьшил с 18 до 16 // Одинаковые скругления
        }
        .buttonStyle(BounceButtonStyle())
    }
}
struct SecondaryActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16) // Изменил с 18 на 16
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Compact Action Button (как на скриншоте)
struct CompactActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Modern Feature Item
struct ModernFeatureItem: View {
    let icon: String
    let text: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.12))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(.green)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Bounce Button Style (более живая анимация)
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .brightness(configuration.isPressed ? -0.1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
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
                            .fill(Color.blue.opacity(0.12))
                            .frame(width: 90, height: 90)
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Проверить статус заявки")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Введите код заявки или номер телефона для поиска вашей заявки")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                VStack(spacing: 24) {
                    Picker("Тип поиска", selection: $selectedOption) {
                        Text("По коду заявки").tag(0)
                        Text("По номеру телефона").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    CustomTextField(
                        title: selectedOption == 0 ? "Введите код заявки (например: AB2024-1234)" : "Введите номер телефона",
                        text: $searchText,
                        systemImage: selectedOption == 0 ? "number.circle" : "phone.circle"
                    )
                }
                
                Button(action: {
                    // TODO: Поиск заявки
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Text("Найти заявку")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
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

#Preview{
    HomeView()
}
