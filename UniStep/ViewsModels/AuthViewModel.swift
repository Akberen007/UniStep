//
//  AuthViewModel.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthService: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        print("👉 Пытаемся войти: \(email)")
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Ошибка входа: \(error.localizedDescription)")
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                print("❌ Нет пользователя в результате входа")
                self?.errorMessage = "No user found"
                completion(false)
                return
            }
            
            print("✅ Вход успешен, UID: \(user.uid)")
            
            self?.fetchUserData(uid: user.uid, completion: completion)
        }
    }
    
    private func fetchUserData(uid: String, completion: @escaping (Bool) -> Void) {
        print("📡 Загружаем данные из Firestore по uid: \(uid)")
        
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Ошибка Firestore: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let doc = snapshot?.documents.first else {
                print("❌ Документ не найден")
                self.errorMessage = "User not found in Firestore"
                completion(false)
                return
            }
            
            let data = doc.data()
            let email = data["email"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            
            print("✅ Firestore: роль — \(role)")
            
            self.currentUser = UserModel(uid: uid, email: email, role: role)
            completion(true)
        }
    }
}
