////
////  StatusBadge.swift
////  UniStep
////
////  Created by Akberen on 28.04.2025.
////
//
//// Views/StatusBadge.swift
//import SwiftUI
//struct StatusBadge: View {
//    var status: ApplicationStatus
//
//    var body: some View {
//        Text(status.rawValue) // Отображаем строку статуса
//            .padding(8)
//            .background(statusColor(status))
//            .foregroundColor(.white)
//            .cornerRadius(8)
//    }
//
//    func statusColor(_ status: ApplicationStatus) -> Color {
//        switch status {
//        case .accepted:
//            return .green
//        case .pending:
//            return .orange
//        case .awaitingDocs:
//            return .gray
//        case .rejected:
//            return .red
//        }
//    }
//}
//
//struct StatusBadge_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusBadge(status: .accepted)
//        StatusBadge(status: .pending)
//        StatusBadge(status: .rejected)
//    }
//}
