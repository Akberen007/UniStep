//
//  UniversityProfileView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import SwiftUI

struct UniversityProfileView: View {
    @EnvironmentObject private var authService: AuthService
    @State private var showLogoutAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Заголовок профиля
                VStack(spacing: 16) {
                    // Логотип
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)
                        
                        Text(getUniversityInitials())
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text(authService.currentUser?.universityName ?? "Университет")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(authService.currentUser?.universityRole?.displayName ?? "Администратор")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                
                // Информация о профиле
                VStack(spacing: 16) {
                    UniversityProfileCard(
                        title: "Контактная информация",
                        icon: "info.circle.fill"
                    ) {
                        VStack(spacing: 12) {
                            UniversityProfileRow(
                                icon: "envelope.fill",
                                title: "Email",
                                value: authService.currentUser?.email ?? "Не указан"
                            )
                            
                            UniversityProfileRow(
                                icon: "building.2.fill",
                                title: "Университет",
                                value: authService.currentUser?.universityName ?? "Не указан"
                            )
                            
                            UniversityProfileRow(
                                icon: "person.badge.key.fill",
                                title: "Роль",
                                value: authService.currentUser?.universityRole?.displayName ?? "Не указана"
                            )
                        }
                    }
                    
                    UniversityProfileCard(
                        title: "Быстрые действия",
                        icon: "bolt.fill"
                    ) {
                        VStack(spacing: 12) {
                            UniversityQuickAction(
                                icon: "square.and.arrow.down.fill",
                                title: "Экспорт заявок",
                                subtitle: "Скачать данные в Excel"
                            ) {
                                // TODO: Реализовать экспорт
                                print("Экспорт заявок")
                            }
                            
                            UniversityQuickAction(
                                icon: "gear.circle.fill",
                                title: "Настройки уведомлений",
                                subtitle: "Управление уведомлениями"
                            ) {
                                // TODO: Реализовать настройки
                                print("Настройки уведомлений")
                            }
                        }
                    }
                }
                
                // Кнопка выхода
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Выйти из аккаунта")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.red, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(20)
        }
        .navigationTitle("Профиль")
        .alert("Выход из аккаунта", isPresented: $showLogoutAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Выйти", role: .destructive) {
                authService.logout()
            }
        } message: {
            Text("Вы уверены, что хотите выйти из аккаунта?")
        }
    }
    
    private func getUniversityInitials() -> String {
        guard let universityName = authService.currentUser?.universityName else { return "У" }
        
        let words = universityName.components(separatedBy: " ")
        if words.count >= 2 {
            let first = String(words[0].prefix(1))
            let second = String(words[1].prefix(1))
            return "\(first)\(second)"
        } else {
            return String(universityName.prefix(2))
        }
    }
}

// MARK: - Profile Card
struct UniversityProfileCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Profile Row
struct UniversityProfileRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .medium))
            }
            
            Spacer()
        }
    }
}

// MARK: - Quick Action
struct UniversityQuickAction: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
