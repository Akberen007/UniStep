//
//  AuthService.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//
import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: UserModel?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Listen for auth state changes
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.loadUserData(uid: user.uid)
            } else {
                self?.currentUser = nil
                self?.isAuthenticated = false
            }
        }
    }
    
    // MARK: - Registration
    func register(with data: RegistrationData) async throws {
        isLoading = true
        
        do {
            // Create Firebase Auth user
            let result = try await auth.createUser(withEmail: data.email, password: data.password)
            
            // Get university name if registering as university
            var universityName: String?
            if data.role == .university {
                universityName = await getUniversityName(id: data.selectedUniversityId)
            }
            
            // Create user document in Firestore
            let user = data.toUserModel(universityName: universityName)
            try await saveUserData(uid: result.user.uid, user: user)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            throw error
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws {
        isLoading = true
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            await loadUserData(uid: result.user.uid)
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            throw error
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
            let user = try document.data(as: UserModel.self)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            print("Error loading user data: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Save User Data
    private func saveUserData(uid: String, user: UserModel) async throws {
        try await db.collection("users").document(uid).setData(from: user)
    }
    
    // MARK: - Get University Name
    private func getUniversityName(id: String) async -> String? {
        // Find university by ID in your universities data
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
    
    // MARK: - Update User Profile
    func updateUserProfile(_ updatedUser: UserModel) async throws {
        guard let currentUser = auth.currentUser else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        try await saveUserData(uid: currentUser.uid, user: updatedUser)
        
        await MainActor.run {
            self.currentUser = updatedUser
        }
    }
}
