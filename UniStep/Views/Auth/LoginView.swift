import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedRole: String = "student"
    @State private var showEmailError = false
    @State private var showPasswordError = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false

    @StateObject private var auth = AuthService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                Text(selectedRole == "student" ? "Student Login" : "University Login")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text(selectedRole == "student" ? "Access your applications" : "Manage your university space")
                    .foregroundColor(.gray)
                    .font(.subheadline)

                RolePicker(selectedRole: $selectedRole)

                // Email Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email address").font(.headline)
                    HStack {
                        Image(systemName: "envelope").foregroundColor(.gray)
                        TextField("example@unistep.kz", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(showEmailError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal)

                // Password Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password").font(.headline)
                    HStack {
                        Image(systemName: "lock").foregroundColor(.gray)
                        SecureField("Only numbers allowed", text: $password)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(showPasswordError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal)

                Text("You will be redirected to your \(selectedRole.capitalized) dashboard")
                    .font(.caption)
                    .foregroundColor(.gray)

                // Sign in button
                Button(action: {
                    showEmailError = !email.contains("@")
                    showPasswordError = password.isEmpty

                    if !showEmailError && !showPasswordError {
                        auth.signIn(email: email, password: password) { success in
                            if success {
                                print("✅ Login success, user: \(auth.currentUser?.role ?? "unknown")")
                                isLoggedIn = true
                            } else {
                                alertMessage = auth.errorMessage ?? "Unknown error"
                                showAlert = true
                            }
                        }
                    }
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()

                NavigationLink(destination: DemoDashboardView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding(.vertical)
            .background(Color(.systemGray6).ignoresSafeArea())
            .alert("Login Failed", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct RolePicker: View {
    @Binding var selectedRole: String
    let roles = ["student", "university"]
    @Namespace var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(roles, id: \.self) { role in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedRole = role
                    }
                }) {
                    Text(role.capitalized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedRole == role ? .white : .black)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selectedRole == role {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red)
                                        .matchedGeometryEffect(id: "picker", in: animation)
                                }
                            }
                        )
                }
            }
        }
        .background(Color.gray.opacity(0.15))
        .clipShape(Capsule())
        .padding(.horizontal)
    }
}

#Preview{
    LoginView()
}



