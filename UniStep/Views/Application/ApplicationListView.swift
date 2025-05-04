////
////  ApplicationListView.swift
////  UniStep
////
////  Created by Akberen on 28.04.2025.
////
//
//// Views/ApplicationListView.swift
//import SwiftUI
//
//struct ApplicationListView: View {
//    @State private var applications: [Application] = []
//
//    var body: some View {
//        NavigationView {
//            List(applications) { application in
//                NavigationLink(destination: ApplicationDetailView(application: application)) {
//                    Text(application.applicantName)
//                        .font(.headline)
//                }
//            }
//            .navigationTitle("Заявки")
//        }
//        .onAppear {
//            // Загрузить заявки
//        }
//    }
//}
//
//#Preview {
//    ApplicationListView()
//}
