//
//  DemoAnalyticsView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//

// DemoAnalyticsView.swift
import SwiftUI

struct DemoAnalyticsView: View {
    var body: some View {
        VStack {
            Spacer()
            
            // Текст, объясняющий, что аналитика недоступна
            Text("Аналитика недоступна в демо")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.red)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            
            // Иконка замка
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.red)
                .padding(.bottom, 20)
            
            // Кнопка "Аналитика" с текстом
            Text("Пожалуйста, зайдите позже для получения информации.")
                .font(.body)
                .foregroundColor(Color.gray)
                .padding(.bottom, 30)
            
            // Кнопка для выхода или перехода
            Button(action: {
                // Логика для перехода, например, на другой экран
            }) {
                Text("ОК")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(width: 200, height: 50)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.bottom, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.white) // Белый фон
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

struct DemoAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAnalyticsView()
    }
}
