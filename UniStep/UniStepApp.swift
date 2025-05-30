//
//  UniStepApp.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//
import SwiftUI
import Firebase

@main
struct UniStepApp: App {
    
    init() {
        FirebaseApp.configure()
        print("🔥 Firebase подключен")
    }

    var body: some Scene {
        WindowGroup {
            HomeView()// или твой стартовый экран
        }
    }
}
