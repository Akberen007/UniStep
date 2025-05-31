
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
    
    @Environment(\.dismiss) private var dismiss
    
    // Генерируем уникальный код заявки
    private var applicationCode: String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let randomNumber = Int.random(in: 1000...9999)
        return "AB\(currentYear)-\(randomNumber)"
    }
    
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
                            
                            Text(applicationCode)
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.1))
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
                        // Save Application Code
                        Button(action: {
                            UIPasteboard.general.string = applicationCode
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Скопировать код заявки")
                                    .font(.system(size: 16, weight: .semibold))
                            }
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
    }
}

// MARK: - Supporting Views
struct ApplicationInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


#Preview {
    ApplicationSuccessView(
        applicantName: "Иван Иванов",
        university: "МУИТ",
        faculty: "Факультет информационных технологий",
        specialty: "Программная инженерия",
        phone: "+7 (777) 123-45-67",
        email: "ivan@example.com"
    )
}

struct NextStepItem: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Step Number
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Text(number)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.red)
            }
            
            // Step Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ApplicationSuccessView(
        applicantName: "Иван Иванов",
        university: "МУИТ",
        faculty: "Факультет информационных технологий",
        specialty: "Программная инженерия",
        phone: "+7 (777) 123-45-67",
        email: "ivan@example.com"
    )
}

// MARK: - Supporting Views

struct DetailRow: View {
    let title: String
    let value: String
    let isHighlighted: Bool
    
    init(title: String, value: String, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.system(size: 15, weight: isHighlighted ? .bold : .medium))
                .foregroundColor(isHighlighted ? .red : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct StepRow: View {
    let number: Int
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Text("\(number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        ApplicationSuccessView(
            applicantName: "Алия Касымова",
            university: "МУИТ",
            faculty: "Факультет информационных технологий",
            specialty: "Программная инженерия",
            phone: "+7 (777) 123-45-67",
            email: "aliya@example.com"
        )
    }
}
