//
//  HomeView.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @State private var navigateToDemo = false
    @State private var showContent = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // 🔹 Логотип и текст
                HStack(spacing: 8) {
                    Image("books1")
                        .resizable()
                        .frame(width: 50, height: 55)
                        .foregroundColor(.red)
                    Text("UniStep")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    NavigationLink(destination: LoginView()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // 🔹 SlideView с серым фоном
                ZStack {
                    SlideView()
                        .padding()
                }
                .padding(.horizontal)
                .frame(height: 260)

                // 🔹 Новый блок преимуществ с листалкой
                AdvantageCarouselView()

                // 🔴 Кнопка "Попробовать демо"
                NavigationLink(destination: DemoLoadingView(), isActive: $navigateToDemo) {
                    EmptyView()
                }

                Button(action: {
                    navigateToDemo = true
                }) {
                    Text("Попробовать демо")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 5)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                .animation(.easeOut(duration: 0.8), value: showContent)
                .navigationBarBackButtonHidden(true)

                // 🔹 Маленький финальный текст
                Text("UniStep помогает университетам упростить приёмную кампанию и работать эффективнее.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: showContent)

                Spacer()
            }
            .padding()
            .onAppear {
                showContent = true
            }
            .background(Color.uniBackground.ignoresSafeArea())
        }
    }
}

#Preview {
    HomeView()
}
