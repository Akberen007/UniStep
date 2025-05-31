
//  ApplicationSuccessView.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import SwiftUI

struct ApplicationSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    let applicationCode = "AB2024-\(String(format: "%04d", Int.random(in: 1000...9999)))"
    let submissionDate = Date()
    
    // Данные заявки (можно передавать из ApplicationFormView)
    let applicantName: String
    let university: String
    let faculty: String
    let specialty: String
    let phone: String
    let email: String
    
    @State private var showShareSheet = false
    @State private var animateSuccess = false
    
    init(applicantName: String,
         university: String,
         faculty: String,
         specialty: String,
         phone: String,
         email: String) {
        self.applicantName = applicantName.isEmpty ? "Не указано" : applicantName
        self.university = university.isEmpty ? "Не выбран" : university
        self.faculty = faculty.isEmpty ? "Не выбран" : faculty
        self.specialty = specialty.isEmpty ? "Не выбрана" : specialty
        self.phone = phone.isEmpty ? "Не указан" : phone
        self.email = email.isEmpty ? "Не указан" : email
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Success Animation Header
                successHeader
                
                // Application Details Card
                applicationDetailsCard
                
                // Next Steps Card
                nextStepsCard
                
                // Important Info Card
                importantInfoCard
                
                // Action Buttons
                actionButtons
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.05), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Заявка подана")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Готово") {
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                animateSuccess = true
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareText])
        }
    }
    
    // MARK: - Success Header
    private var successHeader: some View {
        VStack(spacing: 20) {
            // Animated Success Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.green, Color.green.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
                    .scaleEffect(animateSuccess ? 1 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateSuccess)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateSuccess ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: animateSuccess)
            }
            
            VStack(spacing: 8) {
                Text("Заявка успешно подана!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Ваша заявка принята и будет рассмотрена приемной комиссией")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(animateSuccess ? 1 : 0)
            .offset(y: animateSuccess ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateSuccess)
        }
    }
    
    // MARK: - Application Details Card
    private var applicationDetailsCard: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text("Детали заявки")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                DetailRow(title: "Код заявки", value: applicationCode, isHighlighted: true)
                DetailRow(title: "Дата подачи", value: formatDate(submissionDate))
                DetailRow(title: "Абитуриент", value: applicantName)
                DetailRow(title: "Университет", value: university)
                DetailRow(title: "Факультет", value: faculty)
                DetailRow(title: "Специальность", value: specialty)
                DetailRow(title: "Телефон", value: phone)
                DetailRow(title: "Email", value: email)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // MARK: - Next Steps Card
    private var nextStepsCard: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
                
                Text("Что дальше?")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                StepRow(
                    number: 1,
                    title: "Ожидание рассмотрения",
                    description: "Приемная комиссия рассмотрит вашу заявку в течение 3-5 рабочих дней",
                    color: .blue
                )
                
                StepRow(
                    number: 2,
                    title: "Уведомление о статусе",
                    description: "Вам придет SMS и email с результатом рассмотрения заявки",
                    color: .purple
                )
                
                StepRow(
                    number: 3,
                    title: "Подача документов",
                    description: "При положительном решении подайте оригиналы документов",
                    color: .green
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // MARK: - Important Info Card
    private var importantInfoCard: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                
                Text("Важная информация")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                InfoRow(
                    icon: "bookmark.fill",
                    text: "Сохраните код заявки: \(applicationCode)",
                    color: .red
                )
                
                InfoRow(
                    icon: "clock.fill",
                    text: "Срок действия заявки: до 31 августа 2025 года",
                    color: .orange
                )
                
                InfoRow(
                    icon: "phone.fill",
                    text: "Горячая линия: +7 (727) 123-45-67",
                    color: .blue
                )
                
                InfoRow(
                    icon: "envelope.fill",
                    text: "Email поддержки: support@unistep.kz",
                    color: .green
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Primary Actions
            HStack(spacing: 12) {
                Button(action: {
                    // TODO: Проверить статус заявки
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Проверить статус")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: {
                    showShareSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Поделиться")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
            }
            
            // Secondary Action
            Button(action: {
                dismiss()
            }) {
                Text("Вернуться на главную")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private var shareText: String {
        """
        🎓 Заявка в университет подана!
        
        Код заявки: \(applicationCode)
        Университет: \(university)
        Специальность: \(specialty)
        Дата: \(formatDate(submissionDate))
        
        Подано через UniStep
        """
    }
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
