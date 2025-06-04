//
//  LoginView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//

import SwiftUI

struct LoginView: View {
    let selectedRole: UserRole // Добавляем роль из RoleSelectionView
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showEmailError = false
    @State private var showPasswordError = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var animateFields = false
    @State private var animateButton = false
    
    @EnvironmentObject private var authService: AuthService // Используем новый AuthService
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        VStack(spacing: 16) {
                            Spacer().frame(height: max(60, geometry.safeAreaInsets.top + 20))
                            
                            // Logo with animation
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(selectedRole == .applicant ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: selectedRole.icon)
                                        .font(.system(size: 35, weight: .bold))
                                        .foregroundColor(selectedRole == .applicant ? .blue : .orange)
                                }
                                .scaleEffect(animateFields ? 1 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateFields)
                                
                                VStack(spacing: 8) {
                                    Text("Вход для \(selectedRole.displayName.lowercased())")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                    
                                    Text(selectedRole == .applicant ?
                                        "Войдите чтобы подавать заявки" :
                                        "Управляйте заявками студентов")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .opacity(animateFields ? 1 : 0)
                                .offset(y: animateFields ? 0 : 20)
                                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateFields)
                            }
                            
                            Spacer().frame(height: 40)
                        }

                        // Form Section
                        VStack(spacing: 24) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Электронная почта")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if showEmailError {
                                        Text("Некорректный email")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "envelope")
                                        .foregroundColor(focusedField == .email ?
                                            (selectedRole == .applicant ? .blue : .orange) : .gray)
                                        .frame(width: 20)
                                        .animation(.easeInOut(duration: 0.2), value: focusedField)
                                    
                                    TextField(selectedRole == .applicant ?
                                        "student@unistep.kz" : "admin@university.edu.kz", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .focused($focusedField, equals: .email)
                                        .foregroundColor(.primary)
                                        .accentColor(selectedRole == .applicant ? .blue : .orange)
                                        .onSubmit {
                                            focusedField = .password
                                        }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    showEmailError ? Color.red :
                                                    focusedField == .email ?
                                                        (selectedRole == .applicant ? Color.blue.opacity(0.5) : Color.orange.opacity(0.5)) :
                                                    Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                )
                                .scaleEffect(showEmailError ? 1.02 : 1)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showEmailError)
                            }
                            .opacity(animateFields ? 1 : 0)
                            .offset(x: animateFields ? 0 : -50)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateFields)

                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Пароль")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if showPasswordError {
                                        Text("Обязательное поле")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "lock")
                                        .foregroundColor(focusedField == .password ?
                                            (selectedRole == .applicant ? .blue : .orange) : .gray)
                                        .frame(width: 20)
                                        .animation(.easeInOut(duration: 0.2), value: focusedField)
                                    
                                    Group {
                                        if showPassword {
                                            TextField("Введите пароль", text: $password)
                                        } else {
                                            SecureField("Введите пароль", text: $password)
                                        }
                                    }
                                    .focused($focusedField, equals: .password)
                                    .foregroundColor(.primary)
                                    .accentColor(selectedRole == .applicant ? .blue : .orange)
                                    .onSubmit {
                                        handleLogin()
                                    }
                                    
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showPassword.toggle()
                                        }
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                            .frame(width: 20)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    showPasswordError ? Color.red :
                                                    focusedField == .password ?
                                                        (selectedRole == .applicant ? Color.blue.opacity(0.5) : Color.orange.opacity(0.5)) :
                                                    Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                )
                                .scaleEffect(showPasswordError ? 1.02 : 1)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showPasswordError)
                            }
                            .opacity(animateFields ? 1 : 0)
                            .offset(x: animateFields ? 0 : 50)
                            .animation(.easeOut(duration: 0.6).delay(0.5), value: animateFields)
                        }
                        .padding(.horizontal, 24)

                        Spacer().frame(height: 32)

                        // Login Button
                        Button(action: handleLogin) {
                            HStack(spacing: 12) {
                                Text(isLoading ? "Вход в систему..." : "Войти")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                if !isLoading {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.9)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: isLoading ? [.gray.opacity(0.6)] :
                                                selectedRole == .applicant ? [Color.blue, Color.blue.opacity(0.8)] :
                                                [Color.orange, Color.orange.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(.white)
                            .scaleEffect(animateButton ? 1 : 0.95)
                            .shadow(color: (selectedRole == .applicant ? Color.blue : Color.orange).opacity(0.3),
                                   radius: isLoading ? 0 : 8, x: 0, y: 4)
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 24)
                        .opacity(animateFields ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateFields)

                        Spacer().frame(height: 24)

                        // Additional Options
                        VStack(spacing: 16) {
                            Button(action: {
                                Task {
                                    do {
                                        try await authService.resetPassword(email: email)
                                        alertMessage = "Письмо для сброса пароля отправлено на \(email)"
                                        showAlert = true
                                    } catch {
                                        alertMessage = "Ошибка: \(error.localizedDescription)"
                                        showAlert = true
                                    }
                                }
                            }) {
                                Text("Забыли пароль?")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedRole == .applicant ? .blue : .orange)
                            }
                            
                            HStack(spacing: 4) {
                                Text("Нет аккаунта?")
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    dismiss()
                                }) {
                                    Text("Зарегистрироваться")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(selectedRole == .applicant ? .blue : .orange)
                                }
                            }
                            .font(.system(size: 16))
                        }
                        .opacity(animateFields ? 1 : 0)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateFields)

                        Spacer().frame(height: max(40, geometry.safeAreaInsets.bottom + 20))
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .onAppear {
                withAnimation {
                    animateFields = true
                }
            }
            .alert("Ошибка входа", isPresented: $showAlert) {
                Button("Попробовать снова", role: .cancel) {
                    password = ""
                    focusedField = .email
                }
            } message: {
                Text(alertMessage)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func handleLogin() {
        // Hide keyboard
        focusedField = nil
        
        // Reset errors
        withAnimation(.easeInOut(duration: 0.3)) {
            showEmailError = false
            showPasswordError = false
        }
        
        // Validate input
        var hasErrors = false
        
        if email.isEmpty || !email.contains("@") || !email.contains(".") {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showEmailError = true
            }
            hasErrors = true
        }
        
        if password.isEmpty || password.count < 3 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showPasswordError = true
            }
            hasErrors = true
        }
        
        if hasErrors {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            return
        }
        
        // Start loading
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Use new AuthService
        Task {
            do {
                try await authService.login(email: email, password: password)
                
                // Success haptic
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)
                
                await MainActor.run {
                    dismiss() // Закрываем окно логина, AuthService перенаправит автоматически
                }
                
            } catch {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLoading = false
                    }
                    
                    // Error haptic
                    let errorFeedback = UINotificationFeedbackGenerator()
                    errorFeedback.notificationOccurred(.error)
                    
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    LoginView(selectedRole: .applicant)
        .environmentObject(AuthService.shared)
}
