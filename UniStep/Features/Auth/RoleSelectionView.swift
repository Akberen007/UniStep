//
//  RoleSelectionView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//
import SwiftUI

struct RoleSelectionView: View {
    @State private var showLogin = false
    @State private var showRegistration = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                // Logo
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Панель университета")
                            .font(.system(size: 32, weight: .bold))
                        
                        Text("Управление заявками абитуриентов")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        showLogin = true
                    }) {
                        Text("Войти")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.orange)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {
                        showRegistration = true
                    }) {
                        Text("Регистрация университета")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showLogin) {
            LoginView(selectedRole: .university)
        }
        .sheet(isPresented: $showRegistration) {
            RegistrationView(selectedRole: .university)
        }
    }
}
