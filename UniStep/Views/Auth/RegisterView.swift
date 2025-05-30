import SwiftUI

struct RegisterView: View {
    @State private var universityName = ""
    @State private var shortName = ""
    @State private var login = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isTermsAccepted = false
    @State private var isRegistered = false
    
    @State private var isValidEmail = true  // Флаг для проверки правильности email
    @State private var isPasswordValid = true  // Флаг для проверки пароля
    
    // Регулярное выражение для проверки email
    let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
    
    // Функция для проверки email
    func validateEmail() -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // Функция для проверки пароля (например, минимум 8 символов, включая буквы и цифры)
    func validatePassword() -> Bool {
        let passwordRegex = "(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Заголовок
                Text("Регистрация университета")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.top, 40)

                // Подзаголовок
                Text("Создайте аккаунт для вашего университета на платформе UniStep")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                    .foregroundColor(.gray)

                // Поле для полного названия университета
                CustomTextField(title: "Полное название университета", text: $universityName, systemImage: "building.2.fill")
                
                // Поле для короткого названия
                CustomTextField(title: "Краткое название (для URL)", text: $shortName, systemImage: "abc")
                
                // Поле для логина
                CustomTextField(title: "Логин", text: $login, systemImage: "person.crop.circle.fill")
                
                // Поле для email
                CustomTextField(title: "Email", text: $email, systemImage: "envelope.fill")
                    .onChange(of: email, perform: { _ in
                        isValidEmail = validateEmail() // Проверка email при изменении текста
                    })
                
                if !isValidEmail {
                    Text("Введите корректный email")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Поле для пароля
                CustomTextField(title: "Пароль", text: $password, systemImage: "lock.fill", isSecure: true)
                    .onChange(of: password, perform: { _ in
                        isPasswordValid = validatePassword() // Проверка пароля при изменении текста
                    })
                
                if !isPasswordValid {
                    Text("Пароль должен содержать минимум 8 символов, включая буквы и цифры.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                // Поле для подтверждения пароля
                CustomTextField(title: "Подтвердите пароль", text: $confirmPassword, systemImage: "lock.fill", isSecure: true)
                
                // Чекбокс для согласия с условиями
                HStack {
                    Button(action: {
                        self.isTermsAccepted.toggle()
                    }) {
                        Image(systemName: isTermsAccepted ? "checkmark.square.fill" : "square")
                            .foregroundColor(isTermsAccepted ? .red : .gray)
                    }
                    Text("Я согласен с условиями использования и политикой конфиденциальности")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)

                // Кнопка регистрации
                Button(action: {
                    // Регистрация
                    if universityName != "" && shortName != "" && login != "" && email != "" && password != "" && password == confirmPassword && isValidEmail && isPasswordValid {
                        isRegistered = true
                    }
                }) {
                    Text("Зарегистрироваться")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
                
                // Ссылка на экран входа
                NavigationLink(destination: LoginView()) {
                    Text("Уже есть аккаунт? Войти")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Регистрация")
        }
        .alert(isPresented: $isRegistered) {
            Alert(title: Text("Регистрация успешна"), message: Text("Ваш университет успешно зарегистрирован!"), dismissButton: .default(Text("OK")))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
