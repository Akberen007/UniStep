//
//  UniversityDashboardView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//
import SwiftUI

struct UniversityDashboardView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Список заявок")
                    Text("Скоро будет доступно")
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Заявки")
            }
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Заявки")
            }
            
            NavigationView {
                VStack {
                    Text("Статистика")
                    Text("Скоро будет доступно")
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Статистика")
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Статистика")
            }
            
            NavigationView {
                VStack(spacing: 20) {
                    if let user = authService.currentUser {
                        VStack(spacing: 8) {
                            Text("Профиль университета")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(user.universityName ?? "Название не указано")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Email:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Роль:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(user.universityRole?.displayName ?? "Не указана")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        authService.logout()
                    }) {
                        Text("Выйти из аккаунта")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Профиль")
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Профиль")
            }
        }
        .accentColor(.orange)
    }
}

#Preview {
    UniversityDashboardView()
        .environmentObject(AuthService.shared)
}
