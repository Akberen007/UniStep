//
//  ApplicationFormView.swift
//  UniStep
//
//  Created by Akberen on 28.05.2025.
//

import SwiftUI

struct ApplicationFormView: View {
    @State private var fullName = ""
    @State private var shortName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var cityCountry = ""
    @State private var comment = ""
    @State private var showSuccess = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Оставить заявку")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Group {
                    CustomTextField(title: "Полное название университета", text: $fullName, systemImage: "building.2")
                    CustomTextField(title: "Краткое название (логин)", text: $shortName, systemImage: "person.crop.square")
                    CustomTextField(title: "Email", text: $email, systemImage: "envelope")
                    CustomTextField(title: "Телефон", text: $phone, systemImage: "phone")
                    CustomTextField(title: "Официальный сайт", text: $website, systemImage: "globe")
                    CustomTextField(title: "Город / страна", text: $cityCountry, systemImage: "mappin.and.ellipse")
                }

                VStack(alignment: .leading) {
                    Text("Комментарий (необязательно)")
                        .font(.headline)
                    TextEditor(text: $comment)
                        .frame(height: 100)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                }

                Button(action: {
                    showSuccess = true
                    // Здесь будет сохранение в Firestore в будущем
                }) {
                    Text("Отправить заявку")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .alert("Заявка отправлена", isPresented: $showSuccess, actions: {
            Button("OK", role: .cancel) {}
        })
    }
}


struct ApplicationFormView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationFormView()
    }
}
