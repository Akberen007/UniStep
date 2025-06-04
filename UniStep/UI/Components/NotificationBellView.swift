//
//  NotificationBellView.swift
//  UniStep
//
//  Created by Akberen on 05.05.2025.
//
import SwiftUI

// MARK: - Иконка уведомлений
struct NotificationBellView: View {
    var notificationCount: Int

    var body: some View {
        Image(systemName: "bell")
            .font(.title)
            .foregroundColor(.uniTextSecondary)
            .overlay(
                Text("\(notificationCount)")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.uniRed)
                    .clipShape(Circle())
                    .offset(x: 11, y: -12)
            )
    }
}
