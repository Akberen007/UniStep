import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showFields = false

    var body: some View {
        VStack {
            // Логотип с анимацией
            HStack {
                Image("logo") // Здесь добавьте ваше изображение логотипа
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .animation(.easeIn(duration: 0.5), value: showFields)
            }
            .padding(.top, 100)  // Увеличиваем отступ сверху

            // Поля для ввода
            VStack(spacing: 20) {
                // Email
                TextField("Введите email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.emailAddress)
                    .padding(.top, 30)
                    .opacity(showFields ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: showFields)

                // Пароль
                SecureField("Введите пароль", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .opacity(showFields ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.3), value: showFields)
            }

            // Кнопка Войти с анимацией
            Button(action: {
                // Логика входа
                if !email.isEmpty && !password.isEmpty {
                    isLoggedIn = true
                }
            }) {
                Text("Войти")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .opacity(showFields ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.4), value: showFields)
            }

            // Регистрация
            NavigationLink(destination: RegisterView()) {
                Text("Нет аккаунта? Зарегистрироваться")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                    .opacity(showFields ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.5), value: showFields)
            }
            .padding(.bottom, 40)
            
            Spacer()
        }
        .onAppear {
            showFields = true // Запускаем анимацию при появлении экрана
        }
        .navigationTitle("Вход")
        .navigationBarHidden(true)
        .padding()
        .alert(isPresented: $isLoggedIn) {
            Alert(title: Text("Успех"), message: Text("Вы успешно вошли!"), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//import SwiftUI
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var isLoggedIn: Bool = false
//    @State private var showFields = false
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Spacer() // Это расположит логотип внизу экрана
//                
//                // Логотип с анимацией
//                Image("logo") // Здесь добавьте ваше изображение логотипа
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 250, height: 150)
//                    .padding(.bottom, 20)  // Добавляем отступ снизу
//                    .animation(.easeIn(duration: 0.5), value: showFields)
//                
//                // Поля для ввода
//                VStack(spacing: 20) {
//                    // Email
//                    TextField("Введите email", text: $email)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal, 20)
//                        .keyboardType(.emailAddress)
//                        .padding(.top, 30)
//                        .opacity(showFields ? 1 : 0)
//                        .animation(.easeIn(duration: 0.5).delay(0.2), value: showFields)
//                    
//                    // Пароль
//                    SecureField("Введите пароль", text: $password)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal, 20)
//                        .opacity(showFields ? 1 : 0)
//                        .animation(.easeIn(duration: 0.5).delay(0.3), value: showFields)
//                }
//                
//                // Кнопка Войти с анимацией
//                Button(action: {
//                    // Логика входа
//                    if !email.isEmpty && !password.isEmpty {
//                        isLoggedIn = true
//                    }
//                }) {
//                    Text("Войти")
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                        .padding(.horizontal, 20)
//                        .opacity(showFields ? 1 : 0)
//                        .animation(.easeIn(duration: 0.5).delay(0.4), value: showFields)
//                }
//                
//                // Регистрация
//                NavigationLink(destination: RegisterView()) {
//                    Text("Нет аккаунта? Зарегистрироваться")
//                        .foregroundColor(.black)
//                        .padding(.top, 10)
//                        .opacity(showFields ? 1 : 0)
//                        .animation(.easeIn(duration: 0.5).delay(0.5), value: showFields)
//                }
//                .padding(.bottom, 40)
//                
//                Spacer()
//            }
//            .frame(height: geometry.size.height) // Устанавливаем высоту для GeometryReader
//            .onAppear {
//                showFields = true // Запускаем анимацию при появлении экрана
//            }
//            .navigationTitle("Вход")
//            .navigationBarHidden(true)
//            .padding()
//            .alert(isPresented: $isLoggedIn) {
//                Alert(title: Text("Успех"), message: Text("Вы успешно вошли!"), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
