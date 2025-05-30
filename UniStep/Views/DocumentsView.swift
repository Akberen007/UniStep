//
//  DocumentsView.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import SwiftUI

struct DocumentsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var expandedSection: DocumentCategory? = nil
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                        
                        // Progress Section
                        progressSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: showContent)
                        
                        // Categories Section
                        categoriesSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: showContent)
                        
                        // Help Section
                        helpSection
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: showContent)
                    }
                    .padding(.bottom, max(20, geometry.safeAreaInsets.bottom))
                }
                .scrollIndicators(.hidden)
            }
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.05), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Документы")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Скачать чек-лист
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.15)
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "list.clipboard.fill")
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(showContent ? 1 : 0.8)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1), value: showContent)
            
            VStack(spacing: 8) {
                Text("Необходимые документы")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Подготовьте документы для успешной подачи заявки")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Ваш прогресс")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text("7 из 10")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.orange)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 200, height: 12) // 70% прогресс
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.5), value: showContent)
            }
            
            HStack(spacing: 16) {
                ProgressBadge(icon: "checkmark.circle.fill", title: "Готово", count: 7, color: .green)
                ProgressBadge(icon: "clock.circle.fill", title: "Осталось", count: 3, color: .blue)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Категории документов")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                DocumentCategoryCard(
                    category: .personal,
                    isExpanded: expandedSection == .personal,
                    onTap: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            expandedSection = expandedSection == .personal ? nil : .personal
                        }
                    }
                )
                
                DocumentCategoryCard(
                    category: .education,
                    isExpanded: expandedSection == .education,
                    onTap: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            expandedSection = expandedSection == .education ? nil : .education
                        }
                    }
                )
                
                DocumentCategoryCard(
                    category: .additional,
                    isExpanded: expandedSection == .additional,
                    onTap: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            expandedSection = expandedSection == .additional ? nil : .additional
                        }
                    }
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Help Section
    private var helpSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Нужна помощь?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HelpActionCard(
                    icon: "doc.text.magnifyingglass",
                    title: "Образцы документов",
                    subtitle: "Скачать примеры оформления",
                    color: .blue,
                    action: {
                        // TODO: Скачать образцы
                    }
                )
                
                HelpActionCard(
                    icon: "questionmark.circle.fill",
                    title: "Часто задаваемые вопросы",
                    subtitle: "Ответы на популярные вопросы",
                    color: .purple,
                    action: {
                        // TODO: Открыть FAQ
                    }
                )
                
                HelpActionCard(
                    icon: "phone.fill",
                    title: "Связаться с поддержкой",
                    subtitle: "Получить персональную консультацию",
                    color: .green,
                    action: {
                        // TODO: Контакты поддержки
                    }
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Supporting Models and Views

enum DocumentCategory: CaseIterable {
    case personal, education, additional
    
    var title: String {
        switch self {
        case .personal: return "Личные документы"
        case .education: return "Документы об образовании"
        case .additional: return "Дополнительные документы"
        }
    }
    
    var icon: String {
        switch self {
        case .personal: return "person.text.rectangle"
        case .education: return "graduationcap.fill"
        case .additional: return "doc.badge.plus"
        }
    }
    
    var color: Color {
        switch self {
        case .personal: return .blue
        case .education: return .green
        case .additional: return .purple
        }
    }
    
    var documents: [Document] {
        switch self {
        case .personal:
            return [
                Document(name: "Удостоверение личности", status: .completed, required: true),
                Document(name: "Фотография 3x4", status: .completed, required: true),
                Document(name: "Медицинская справка", status: .pending, required: true)
            ]
        case .education:
            return [
                Document(name: "Аттестат о среднем образовании", status: .completed, required: true),
                Document(name: "Приложение с оценками", status: .completed, required: true),
                Document(name: "Результаты ЕНТ", status: .completed, required: true),
                Document(name: "Сертификат IELTS/TOEFL", status: .pending, required: false)
            ]
        case .additional:
            return [
                Document(name: "Справка о льготах", status: .notStarted, required: false),
                Document(name: "Портфолио", status: .pending, required: false),
                Document(name: "Рекомендательные письма", status: .notStarted, required: false)
            ]
        }
    }
}

struct Document {
    let name: String
    let status: DocumentStatus
    let required: Bool
}

enum DocumentStatus {
    case completed, pending, notStarted
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .pending: return .orange
        case .notStarted: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .pending: return "clock.circle.fill"
        case .notStarted: return "circle"
        }
    }
}

struct ProgressBadge: View {
    let icon: String
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text("\(count)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct DocumentCategoryCard: View {
    let category: DocumentCategory
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(category.color.opacity(0.15))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(category.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("\(category.documents.filter { $0.status == .completed }.count) из \(category.documents.count) готово")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(category.documents.indices, id: \.self) { index in
                        DocumentRow(document: category.documents[index])
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct DocumentRow: View {
    let document: Document
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: document.status.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(document.status.color)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(document.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    if document.required {
                        Text("*")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
                
                Text(document.required ? "Обязательный документ" : "Дополнительный документ")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if document.status != .completed {
                Button(action: {
                    // TODO: Загрузить документ
                }) {
                    Text("Загрузить")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                        )
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct HelpActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DocumentsView()
}
