//
//  DemoSettingsView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//

// DemoSettingsView.swift
import SwiftUI

struct DemoSettingsView: View {
    @State private var navigateToHome: Bool = false // Переменная для управления переходом

    var body: some View {
        NavigationStack {
            VStack {
                Text("Настройки демо-университета")
                    .font(.title)
                    .padding()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Университет: Демонстрационный ВУЗ")
                    Text("Email: demo@unistep.kz")

                    Button(action: {
                        // Логика регистрации для полного доступа
                    }) {
                        Text("Зарегистрировать университет")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Логика выхода из демо
                        navigateToHome = true // Устанавливаем флаг для перехода на домашнюю страницу
                    }) {
                        Text("Выйти из демо")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                
                // NavigationLink для перехода на DemoHomeView
                NavigationLink(
                    destination: HomeView(),
                    isActive: $navigateToHome,
                    label: { EmptyView() } // Invisible link
                )
            }
            .navigationBarBackButtonHidden(true) // Убирает кнопку back
        }
    }
}

#Preview {
    DemoSettingsView()
}
