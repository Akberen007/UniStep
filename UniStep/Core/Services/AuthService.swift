//
//  AuthService.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: UserModel?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {
        // Listen for auth state changes
        auth.addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    await self?.loadUserData(uid: user.uid)
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Registration
    func register(with data: RegistrationData) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Create Firebase Auth user
            let result = try await auth.createUser(withEmail: data.email, password: data.password)
            
            // Get university name if registering as university
            var universityName: String?
            if data.role == .university {
                universityName = getUniversityName(id: data.selectedUniversityId)
            }
            
            // Create user document in Firestore
            let user = data.toUserModel(universityName: universityName)
            try await saveUserData(uid: result.user.uid, user: user)
            
            self.currentUser = user
            self.isAuthenticated = true
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            await loadUserData(uid: result.user.uid)
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Legacy signIn method (для совместимости с вашим старым кодом)
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await login(email: email, password: password)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        do {
            try auth.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    // MARK: - Load User Data
    private func loadUserData(uid: String) async {
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            
            if document.exists {
                let user = try document.data(as: UserModel.self)
                self.currentUser = user
                self.isAuthenticated = true
            } else {
                // If user document doesn't exist, create a basic one
                let basicUser = UserModel(
                    id: uid,
                    email: auth.currentUser?.email ?? "",
                    role: .applicant, // UserRole, не String
                    createdAt: Date(),
                    isActive: true,
                    firstName: nil,
                    lastName: nil,
                    phoneNumber: nil,
                    universityId: nil,
                    universityName: nil,
                    universityRole: nil,
                    permissions: nil
                )
                try await saveUserData(uid: uid, user: basicUser)
                self.currentUser = basicUser
                self.isAuthenticated = true
            }
            
            self.isLoading = false
        } catch {
            print("Error loading user data: \(error)")
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Save User Data
    private func saveUserData(uid: String, user: UserModel) async throws {
        var userToSave = user
        userToSave.id = uid
        try await db.collection("users").document(uid).setData(from: userToSave)
    }
    
    // MARK: - Get University Name
    private func getUniversityName(id: String) -> String? {
        let university = universitiesData.first { university in
            university.shortName == id || university.name.contains(id)
        }
        return university?.name
    }
    
    // MARK: - Check Permissions
    func hasPermission(_ permission: Permission) -> Bool {
        guard let user = currentUser,
              user.role == .university,
              let permissions = user.permissions else {
            return false
        }
        return permissions.contains(permission)
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
}
