//
//  CustomTextField.swift
//  UniStep
//
//  Created by Akberen on 28.04.2025.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var systemImage: String
    var isSecure: Bool = false
    var errorMessage: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 20)
                
                if isSecure {
                    SecureField(title, text: $text)
                        .font(.system(size: 16))
                } else {
                    TextField(title, text: $text)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .frame(height: 48)
            
            // Показываем ошибку, если она есть
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .padding(.horizontal)
    }
}
#Preview {
    VStack(spacing: 16) {
        CustomTextField(title: "Email", text: .constant(""), systemImage: "envelope")
        CustomTextField(title: "Пароль", text: .constant(""), systemImage: "lock", isSecure: true)
        CustomTextField(title: "Телефон", text: .constant(""), systemImage: "phone")
    }
    .padding()
}
