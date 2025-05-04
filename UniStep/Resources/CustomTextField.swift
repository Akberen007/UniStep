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

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24) // Уменьшаем размер иконки

            if isSecure {
                SecureField(title, text: $text)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(height: 48) // Устанавливаем фиксированную высоту для поля
            } else {
                TextField(title, text: $text)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(height: 48) // Устанавливаем фиксированную высоту для поля
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTextField(title: "Email", text: .constant(""), systemImage: "envelope")
}
