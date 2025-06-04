//
//  RegistrationView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//

import SwiftUI

struct RegistrationView: View {
    let selectedRole: UserRole // Роль из RoleSelectionView
    
    @State private var registrationData = RegistrationData()
    @State private var confirmPassword = ""
    @State private var isTermsAccepted = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // Validation states
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""
    
    @EnvironmentObject private var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    // Available universities for university registration
    let availableUniversities = universitiesData
    
    init(selectedRole: UserRole) {
        self.selectedRole = selectedRole
        self._registrationData = State(initialValue: {
            var data = RegistrationData()
            data.role = selectedRole
            return data
        }())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Form based on role
                    if selectedRole == .applicant {
                        applicantForm
                    } else {
                        universityForm
                    }
                    
                    // Terms and Registration
                    termsAndRegistrationSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") {
                        dismiss()
                    }
                }
            }
            .alert(alertMessage.contains("успешно") ? "Успешно" : "Ошибка",
                   isPresented: $showAlert) {
                Button("OK") {
                    if alertMessage.contains("успешно") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(selectedRole == .applicant ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: selectedRole.icon)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(selectedRole == .applicant ? .blue : .orange)
            }
            
            VStack(spacing: 8) {
                Text("Регистрация \(selectedRole.displayName.lowercased())")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(selectedRole == .applicant ?
                    "Создайте аккаунт для подачи заявок" :
                    "Зарегистрируйте ваш университет")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Applicant Form
    private var applicantForm: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: "Введите ваше имя",
                text: $registrationData.firstName,
                systemImage: "person.fill"
            )
            
            CustomTextField(
                title: "Введите вашу фамилию",
                text: $registrationData.lastName,
                systemImage: "person.fill"
            )
            
            CustomTextField(
                title: "+7 (___) ___-__-__",
                text: $registrationData.phoneNumber,
                systemImage: "phone.fill"
            )
            
            VStack(alignment: .leading, spacing: 4) {
                CustomTextField(
                    title: "student@example.com",
                    text: $registrationData.email,
                    systemImage: "envelope.fill",
                    errorMessage: emailError
                )
            }
            .onChange(of: registrationData.email) { _ in
                validateEmail()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                CustomTextField(
                    title: "Минимум 8 символов",
                    text: $registrationData.password,
                    systemImage: "lock.fill",
                    isSecure: true,
                    errorMessage: passwordError
                )
            }
            .onChange(of: registrationData.password) { _ in
                validatePassword()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                CustomTextField(
                    title: "Повторите пароль",
                    text: $confirmPassword,
                    systemImage: "lock.fill",
                    isSecure: true,
                    errorMessage: confirmPasswordError
                )
            }
            .onChange(of: confirmPassword) { _ in
                validateConfirmPassword()
            }
        }
    }
    
    // MARK: - University Form
    private var universityForm: some View {
        VStack(spacing: 20) {
            // University Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Выберите университет")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Menu {
                    ForEach(availableUniversities, id: \.shortName) { university in
                        Button(action: {
                            registrationData.selectedUniversityId = university.shortName
                        }) {
                            Text("\(university.shortName) - \(university.name)")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "building.columns.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        Text(registrationData.selectedUniversityId.isEmpty ?
                            "Выберите университет" :
                            registrationData.selectedUniversityId)
                            .foregroundColor(registrationData.selectedUniversityId.isEmpty ? .gray : .primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            // University Role Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Ваша должность")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Menu {
                    ForEach(UniversityRole.allCases, id: \.self) { role in
                        Button(action: {
                            registrationData.universityRole = role
                        }) {
                            Text(role.displayName)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        Text(registrationData.universityRole.displayName)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            CustomTextField(
                title: "admin@university.edu.kz",
                text: $registrationData.email,
                systemImage: "envelope.fill",
                errorMessage: emailError
            )
            .onChange(of: registrationData.email) { _ in
                validateEmail()
            }
            
            CustomTextField(
                title: "Минимум 8 символов",
                text: $registrationData.password,
                systemImage: "lock.fill",
                isSecure: true,
                errorMessage: passwordError
            )
            .onChange(of: registrationData.password) { _ in
                validatePassword()
            }
            
            CustomTextField(
                title: "Повторите пароль",
                text: $confirmPassword,
                systemImage: "lock.fill",
                isSecure: true,
                errorMessage: confirmPasswordError
            )
            .onChange(of: confirmPassword) { _ in
                validateConfirmPassword()
            }
        }
    }
    
    // MARK: - Terms and Registration Section
    private var termsAndRegistrationSection: some View {
        VStack(spacing: 20) {
            // Terms checkbox
            HStack(alignment: .top, spacing: 12) {
                Button(action: {
                    isTermsAccepted.toggle()
                }) {
                    Image(systemName: isTermsAccepted ? "checkmark.square.fill" : "square")
                        .foregroundColor(isTermsAccepted ?
                            (selectedRole == .applicant ? .blue : .orange) : .gray)
                        .font(.system(size: 20))
                }
                
                Text("Я согласен с условиями использования и политикой конфиденциальности UniStep")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            // Registration button
            Button(action: handleRegistration) {
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.9)
                            .foregroundColor(.white)
                    }
                    
                    Text(isLoading ? "Регистрация..." : "Зарегистрироваться")
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: selectedRole == .applicant ?
                                    [Color.blue, Color.blue.opacity(0.8)] :
                                    [Color.orange, Color.orange.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .foregroundColor(.white)
                .shadow(color: (selectedRole == .applicant ? Color.blue : Color.orange).opacity(0.3),
                       radius: 8, x: 0, y: 4)
            }
            .disabled(isLoading || !isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
        }
    }
    
    // MARK: - Validation
    private var isFormValid: Bool {
        let basicValidation = !registrationData.email.isEmpty &&
                             !registrationData.password.isEmpty &&
                             confirmPassword == registrationData.password &&
                             isTermsAccepted &&
                             emailError.isEmpty &&
                             passwordError.isEmpty &&
                             confirmPasswordError.isEmpty
        
        if selectedRole == .applicant {
            return basicValidation &&
                   !registrationData.firstName.isEmpty &&
                   !registrationData.lastName.isEmpty &&
                   !registrationData.phoneNumber.isEmpty
        } else {
            return basicValidation &&
                   !registrationData.selectedUniversityId.isEmpty
        }
    }
    
    private func validateEmail() {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if registrationData.email.isEmpty {
            emailError = ""
        } else if !emailTest.evaluate(with: registrationData.email) {
            emailError = "Введите корректный email"
        } else {
            emailError = ""
        }
    }
    
    private func validatePassword() {
        if registrationData.password.isEmpty {
            passwordError = ""
        } else if registrationData.password.count < 8 {
            passwordError = "Минимум 8 символов"
        } else {
            passwordError = ""
            validateConfirmPassword() // Re-validate confirm password
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = ""
        } else if confirmPassword != registrationData.password {
            confirmPasswordError = "Пароли не совпадают"
        } else {
            confirmPasswordError = ""
        }
    }
    
    private func handleRegistration() {
        isLoading = true
        
        Task {
            do {
                try await authService.register(with: registrationData)
                
                await MainActor.run {
                    alertMessage = "Регистрация прошла успешно!"
                    showAlert = true
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    alertMessage = "Ошибка регистрации: \(error.localizedDescription)"
                    showAlert = true
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RegistrationView(selectedRole: .applicant)
        .environmentObject(AuthService.shared)
}
