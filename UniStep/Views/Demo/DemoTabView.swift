//
//  DemoTabView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//

// DemoTabView.swift
import SwiftUI

struct DemoTabView: View {
    var body: some View {
        HStack {
            // Заявки
            NavigationLink(destination: DemoApplicationsView()) {
                Image(systemName: "doc.text.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Аналитика
            NavigationLink(destination: DemoAnalyticsView()) {
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Настройки
            NavigationLink(destination: DemoSettingsView()) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}
