//  ApplicationSuccessView.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import SwiftUI

struct ApplicationSuccessView: View {
    let applicantName: String
    let university: String
    let faculty: String
    let specialty: String
    let phone: String
    let email: String
    let applicationId: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedAlert = false // ✅ ДОБАВЛЕНО для уведомления
    
    // ✅ УДАЛЯЕМ старую генерацию - теперь используем переданный ID
    // private var applicationCode: String { ... } - УДАЛЕНО
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Success Animation & Icon
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 90, height: 90)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Заявка подана успешно!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Ваша заявка принята и будет рассмотрена приемной комиссией")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                    }
                    
                    // Application Details Card
                    VStack(spacing: 20) {
                        // Application Code
                        VStack(spacing: 12) {
                            Text("Код заявки")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            // ✅ ИСПРАВЛЕНО: Используем переданный applicationId
                            Text(applicationId)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Application Info
                        VStack(spacing: 16) {
                            ApplicationInfoRow(title: "Абитуриент", value: applicantName)
                            ApplicationInfoRow(title: "Университет", value: university)
                            ApplicationInfoRow(title: "Факультет", value: faculty)
                            ApplicationInfoRow(title: "Специальность", value: specialty)
                            ApplicationInfoRow(title: "Телефон", value: phone)
                            ApplicationInfoRow(title: "Email", value: email)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }
                    
                    // Next Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Что дальше?")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            NextStepItem(
                                number: "1",
                                title: "Ожидание рассмотрения",
                                description: "Приемная комиссия рассмотрит вашу заявку в течение 3-5 рабочих дней"
                            )
                            
                            NextStepItem(
                                number: "2",
                                title: "Уведомление",
                                description: "Вам придет SMS или звонок с результатами рассмотрения"
                            )
                            
                            NextStepItem(
                                number: "3",
                                title: "Подача документов",
                                description: "При положительном решении принесите оригиналы документов"
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // ✅ ИСПРАВЛЕНО: Кнопка копирования с правильной функцией
                        Button(action: {
                            copyApplicationId()
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Скопировать код заявки")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                        }
                        
                        // Back to Home
                        Button(action: {
                            // Закрываем все экраны и возвращаемся на главную
                            dismiss()
                        }) {
                            Text("Вернуться на главную")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red)
                                )
                        }
                    }
                }
                .padding(20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        // ✅ ДОБАВЛЕНО: Alert для подтверждения копирования
        .alert("Скопировано!", isPresented: $showCopiedAlert) {
            Button("OK") { }
        } message: {
            Text("Код заявки скопирован в буфер обмена")
        }
    }
    
    // ✅ ДОБАВЛЕНО: Функция копирования ID в буфер обмена
    private func copyApplicationId() {
        UIPasteboard.general.string = applicationId
        showCopiedAlert = true
        
        // Добавляем тактильную обратную связь
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        print("✅ Код заявки скопирован: \(applicationId)")
    }
}


