//
//  DemoHomeView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//

// DemoHomeView.swift
import SwiftUI

struct DemoHomeView: View {
    var body: some View {
        VStack {
            // TabView с основными разделами
            TabView {
                DemoDashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Главная")
                    }
                
                DemoApplicationsView()
                    .tabItem {
                        Image(systemName: "doc.fill")
                        Text("Заявки")
                            
                    }
                
                DemoAnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Аналитика")
                    }
                
                DemoSettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Настройки")
                    }
            }
            .accentColor(.red) // Цвет для активной вкладки
        }
        .navigationBarBackButtonHidden(true) // Отключаем кнопку "Back" в навигации
    }
}

#Preview {
    DemoHomeView()
}
