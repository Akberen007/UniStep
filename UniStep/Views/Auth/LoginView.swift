////import SwiftUI
////
////struct LoginView: View {
////    @State private var email: String = ""
////    @State private var password: String = ""
////    @State private var selectedRole: String = "student"
////    @State private var showEmailError = false
////    @State private var showPasswordError = false
////    @State private var showAlert = false
////    @State private var alertMessage = ""
////    @State private var isLoggedIn = false
////
////    @StateObject private var auth = AuthService()
////
////    var body: some View {
////        NavigationStack {
////            VStack(spacing: 20) {
////                Spacer().frame(height: 40)
////
////                Text(selectedRole == "student" ? "Student Login" : "University Login")
////                    .font(.system(size: 28, weight: .bold, design: .rounded))
////
////                Text(selectedRole == "student" ? "Access your applications" : "Manage your university space")
////                    .foregroundColor(.gray)
////                    .font(.subheadline)
////
////                RolePicker(selectedRole: $selectedRole)
////
////                // Email Field
////                VStack(alignment: .leading, spacing: 4) {
////                    Text("Email address").font(.headline)
////                    HStack {
////                        Image(systemName: "envelope").foregroundColor(.gray)
////                        TextField("example@unistep.kz", text: $email)
////                            .keyboardType(.emailAddress)
////                            .autocapitalization(.none)
////                            .disableAutocorrection(true)
////                    }
////                    .padding()
////                    .background(RoundedRectangle(cornerRadius: 10)
////                        .stroke(showEmailError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1))
////                }
////                .padding(.horizontal)
////
////                // Password Field
////                VStack(alignment: .leading, spacing: 4) {
////                    Text("Password").font(.headline)
////                    HStack {
////                        Image(systemName: "lock").foregroundColor(.gray)
////                        SecureField("Only numbers allowed", text: $password)
////                    }
////                    .padding()
////                    .background(RoundedRectangle(cornerRadius: 10)
////                        .stroke(showPasswordError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1))
////                }
////                .padding(.horizontal)
////
////                Text("You will be redirected to your \(selectedRole.capitalized) dashboard")
////                    .font(.caption)
////                    .foregroundColor(.gray)
////
////                // Sign in button
////                Button(action: {
////                    showEmailError = !email.contains("@")
////                    showPasswordError = password.isEmpty
////
////                    if !showEmailError && !showPasswordError {
////                        auth.signIn(email: email, password: password) { success in
////                            if success {
////                                print("✅ Login success, user: \(auth.currentUser?.role ?? "unknown")")
////                                isLoggedIn = true
////                            } else {
////                                alertMessage = auth.errorMessage ?? "Unknown error"
////                                showAlert = true
////                            }
////                        }
////                    }
////                }) {
////                    Text("Sign in")
////                        .frame(maxWidth: .infinity)
////                        .padding()
////                        .background(Color.red)
////                        .foregroundColor(.white)
////                        .cornerRadius(12)
////                }
////                .padding(.horizontal)
////
////                Spacer()
////
////                NavigationLink(destination: DemoDashboardView(), isActive: $isLoggedIn) {
////                    EmptyView()
////                }
////            }
////            .padding(.vertical)
////            .background(Color(.systemGray6).ignoresSafeArea())
////            .alert("Login Failed", isPresented: $showAlert) {
////                Button("OK", role: .cancel) {}
////            } message: {
////                Text(alertMessage)
////            }
////        }
////    }
////}
////
////struct RolePicker: View {
////    @Binding var selectedRole: String
////    let roles = ["student", "university"]
////    @Namespace var animation
////
////    var body: some View {
////        HStack(spacing: 0) {
////            ForEach(roles, id: \.self) { role in
////                Button(action: {
////                    withAnimation(.spring()) {
////                        selectedRole = role
////                    }
////                }) {
////                    Text(role.capitalized)
////                        .font(.system(size: 16, weight: .semibold))
////                        .foregroundColor(selectedRole == role ? .white : .black)
////                        .padding(.vertical, 10)
////                        .frame(maxWidth: .infinity)
////                        .background(
////                            ZStack {
////                                if selectedRole == role {
////                                    RoundedRectangle(cornerRadius: 20)
////                                        .fill(Color.red)
////                                        .matchedGeometryEffect(id: "picker", in: animation)
////                                }
////                            }
////                        )
////                }
////            }
////        }
////        .background(Color.gray.opacity(0.15))
////        .clipShape(Capsule())
////        .padding(.horizontal)
////    }
////}
////
////#Preview{
////    LoginView()
////}
////
////
////
//
//import SwiftUI
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var showEmailError = false
//    @State private var showPasswordError = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var isLoggedIn = false
//    @State private var isLoading = false
//
//    @StateObject private var auth = AuthService()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//                Spacer().frame(height: 60)
//                
//                // Header
//                VStack(spacing: 8) {
//                    Image("books1")
//                        .resizable()
//                        .frame(width: 48, height: 54)
//                    
//                    Text("Вход в UniStep")
//                        .font(.system(size: 28, weight: .bold, design: .rounded))
//                    
//                    Text("Добро пожаловать в платформу цифровизации")
//                        .foregroundColor(.gray)
//                        .font(.subheadline)
//                        .multilineTextAlignment(.center)
//                }
//                .padding(.horizontal)
//
//                Spacer().frame(height: 20)
//
//                // Login Form
//                VStack(spacing: 20) {
//                    // Email Field
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Email")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        
//                        HStack(spacing: 12) {
//                            Image(systemName: "envelope")
//                                .foregroundColor(.gray)
//                                .frame(width: 20)
//                            
//                            TextField("example@unistep.kz", text: $email)
//                                .keyboardType(.emailAddress)
//                                .autocapitalization(.none)
//                                .disableAutocorrection(true)
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(showEmailError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
//                        )
//                        
//                        if showEmailError {
//                            Text("Введите корректный email")
//                                .font(.caption)
//                                .foregroundColor(.red)
//                        }
//                    }
//
//                    // Password Field
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Пароль")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                        
//                        HStack(spacing: 12) {
//                            Image(systemName: "lock")
//                                .foregroundColor(.gray)
//                                .frame(width: 20)
//                            
//                            SecureField("Введите пароль", text: $password)
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(showPasswordError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
//                        )
//                        
//                        if showPasswordError {
//                            Text("Пароль не может быть пустым")
//                                .font(.caption)
//                                .foregroundColor(.red)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//
//                // Info text
//                Text("После входа вы будете перенаправлены в соответствующий раздел")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                // Sign in button
//                Button(action: handleLogin) {
//                    HStack {
//                        if isLoading {
//                            ProgressView()
//                                .scaleEffect(0.8)
//                                .foregroundColor(.white)
//                        }
//                        
//                        Text(isLoading ? "Вход..." : "Войти")
//                            .fontWeight(.semibold)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                }
//                .disabled(isLoading)
//                .padding(.horizontal)
//
//                // Additional options
//                VStack(spacing: 12) {
//                    Button(action: {
//                        // TODO: Forgot password
//                    }) {
//                        Text("Забыли пароль?")
//                            .font(.subheadline)
//                            .foregroundColor(.red)
//                    }
//                    
//                    HStack {
//                        Text("Нет аккаунта?")
//                            .foregroundColor(.gray)
//                        
//                        Button(action: {
//                            // TODO: Registration
//                        }) {
//                            Text("Зарегистрироваться")
//                                .foregroundColor(.red)
//                                .fontWeight(.medium)
//                        }
//                    }
//                    .font(.subheadline)
//                }
//
//                Spacer()
//
//                // Hidden navigation
//                NavigationLink(destination: DemoDashboardView(), isActive: $isLoggedIn) {
//                    EmptyView()
//                }
//            }
//            .padding(.vertical)
//            .background(Color.uniBackground.ignoresSafeArea())
//            .alert("Ошибка входа", isPresented: $showAlert) {
//                Button("OK", role: .cancel) {}
//            } message: {
//                Text(alertMessage)
//            }
//        }
//    }
//    
//    private func handleLogin() {
//        // Reset errors
//        showEmailError = false
//        showPasswordError = false
//        
//        // Validate input
//        if email.isEmpty || !email.contains("@") {
//            showEmailError = true
//        }
//        
//        if password.isEmpty {
//            showPasswordError = true
//        }
//        
//        // If validation passes, attempt login
//        if !showEmailError && !showPasswordError {
//            isLoading = true
//            
//            auth.signIn(email: email, password: password) { success in
//                DispatchQueue.main.async {
//                    isLoading = false
//                    
//                    if success {
//                        print("✅ Login success, user role: \(auth.currentUser?.role ?? "unknown")")
//                        isLoggedIn = true
//                    } else {
//                        alertMessage = auth.errorMessage ?? "Неизвестная ошибка"
//                        showAlert = true
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    LoginView()
//}

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showEmailError = false
    @State private var showPasswordError = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var animateFields = false
    @State private var animateButton = false

    @StateObject private var auth = AuthService()
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
                                        .fill(Color.red.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    Image("books1")
                                        .resizable()
                                        .frame(width: 40, height: 45)
                                        .foregroundColor(.red)
                                }
                                .scaleEffect(animateFields ? 1 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateFields)
                                
                                VStack(spacing: 8) {
                                    Text("Добро пожаловать")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                    
                                    Text("Войдите в свой аккаунт UniStep")
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
                                        .foregroundColor(focusedField == .email ? .red : .gray)
                                        .frame(width: 20)
                                        .animation(.easeInOut(duration: 0.2), value: focusedField)
                                    
                                    TextField("example@unistep.kz", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .focused($focusedField, equals: .email)
                                        .foregroundColor(.primary)
                                        .accentColor(.red)
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
                                                    focusedField == .email ? Color.red.opacity(0.5) :
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
                                        .foregroundColor(focusedField == .password ? .red : .gray)
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
                                    .accentColor(.red)
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
                                                    focusedField == .password ? Color.red.opacity(0.5) :
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
                                            colors: isLoading ? [.gray.opacity(0.6)] : [Color.red, Color.red.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(.white)
                            .scaleEffect(animateButton ? 1 : 0.95)
                            .shadow(color: Color.red.opacity(0.3), radius: isLoading ? 0 : 8, x: 0, y: 4)
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 24)
                        .opacity(animateFields ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateFields)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                animateButton = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    animateButton = false
                                }
                            }
                        }

                        Spacer().frame(height: 24)

                        // Additional Options
                        VStack(spacing: 16) {
                            Button(action: {
                                // TODO: Forgot password
                            }) {
                                Text("Забыли пароль?")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            
                            HStack(spacing: 4) {
                                Text("Нет аккаунта?")
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    // TODO: Registration
                                }) {
                                    Text("Зарегистрироваться")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.red)
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
                    // Reset form
                    password = ""
                    focusedField = .email
                }
            } message: {
                Text(alertMessage)
            }
            .navigationBarHidden(true)
            
            // Hidden navigation
            NavigationLink(destination: DemoDashboardView(), isActive: $isLoggedIn) {
                EmptyView()
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
            // Haptic feedback for errors
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            return
        }
        
        // Start loading
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        
        // Haptic feedback for success
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        auth.signIn(email: email, password: password) { success in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isLoading = false
                }
                
                if success {
                    print("✅ Login success, user role: \(auth.currentUser?.role ?? "unknown")")
                    
                    // Success haptic
                    let successFeedback = UINotificationFeedbackGenerator()
                    successFeedback.notificationOccurred(.success)
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isLoggedIn = true
                    }
                } else {
                    // Error haptic
                    let errorFeedback = UINotificationFeedbackGenerator()
                    errorFeedback.notificationOccurred(.error)
                    
                    alertMessage = auth.errorMessage ?? "Проверьте правильность данных"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
