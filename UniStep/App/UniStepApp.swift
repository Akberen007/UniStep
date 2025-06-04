//
//  UniStepApp.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//

import SwiftUI
import FirebaseCore

@main
struct UniStepApp: App {
    @StateObject private var authService = AuthService.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated, let user = authService.currentUser {
                    // Только университеты попадают сюда
                    UniversityDashboardView()
                } else {
                    // Главная страница для всех (абитуриенты и гости)
                    HomeView()
                }
            }
            .environmentObject(authService)
        }
    }
}
