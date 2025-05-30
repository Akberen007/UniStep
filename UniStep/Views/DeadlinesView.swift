
//
//  DeadlinesView.swift
//  UniStep
//
//  Created by Akberen on 01.06.2025.
//

import SwiftUI

struct DeadlinesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var selectedTab = 0
    @State private var timeRemaining = TimeInterval(1987200) // 23 дня в секундах
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                        
                        // Countdown Section
                        countdownSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: showContent)
                        
                        // Tabs Section
                        tabsSection
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: showContent)
                        
                        // Timeline Section
                        timelineSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: showContent)
                        
                        // Important Notes
                        importantNotesSection
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: showContent)
                    }
                    .padding(.bottom, max(20, geometry.safeAreaInsets.bottom))
                }
                .scrollIndicators(.hidden)
            }
            .background(
                LinearGradient(
                    colors: [Color.indigo.opacity(0.05), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Сроки подачи")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Добавить в календарь
                    }) {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(.indigo)
            }
            .scaleEffect(showContent ? 1 : 0.8)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1), value: showContent)
            
            VStack(spacing: 8) {
                Text("Важные даты")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Не пропустите сроки подачи документов в 2025 году")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Countdown Section
    private var countdownSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("До окончания приема документов")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    CountdownUnit(value: Int(timeRemaining) / 86400, label: "дней", color: .red)
                    CountdownUnit(value: (Int(timeRemaining) % 86400) / 3600, label: "часов", color: .orange)
                    CountdownUnit(value: (Int(timeRemaining) % 3600) / 60, label: "минут", color: .blue)
                    CountdownUnit(value: Int(timeRemaining) % 60, label: "секунд", color: .green)
                }
            }
            
            VStack(spacing: 12) {
                Text("Крайний срок: 15 июля 2025")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.red)
                
                Text("После этой даты подача документов будет невозможна")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .red.opacity(0.1), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Tabs Section
    private var tabsSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TabButton(title: "Бакалавриат", isSelected: selectedTab == 0) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = 0
                    }
                }
                
                TabButton(title: "Магистратура", isSelected: selectedTab == 1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = 1
                    }
                }
                
                TabButton(title: "Докторантура", isSelected: selectedTab == 2) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = 2
                    }
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    // MARK: - Timeline Section
    private var timelineSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Календарь событий")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                ForEach(getTimelineEvents(), id: \.id) { event in
                    TimelineEventCard(event: event)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Important Notes Section
    private var importantNotesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Важная информация")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ImportantNoteCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "Документы нужно подать заранее",
                    description: "Рекомендуем подавать документы минимум за 7 дней до крайнего срока",
                    color: .orange
                )
                
                ImportantNoteCard(
                    icon: "clock.arrow.circlepath",
                    title: "Время подачи",
                    description: "Документы принимаются с 9:00 до 18:00 по времени Алматы",
                    color: .blue
                )
                
                ImportantNoteCard(
                    icon: "phone.fill",
                    title: "Нужна помощь?",
                    description: "Горячая линия: +7 (727) 123-45-67 (круглосуточно)",
                    color: .green
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
    
    // MARK: - Helper Functions
    private func getTimelineEvents() -> [TimelineEvent] {
        switch selectedTab {
        case 0: // Бакалавриат
            return [
                TimelineEvent(id: 1, date: "1 июня", title: "Начало приема документов", description: "Открыта подача заявок на все специальности", status: .completed, color: .green),
                TimelineEvent(id: 2, date: "15 июня", title: "Результаты ЕНТ", description: "Публикация результатов Единого национального тестирования", status: .current, color: .blue),
                TimelineEvent(id: 3, date: "1 июля", title: "Дополнительные экзамены", description: "Проведение внутренних экзаменов университетов", status: .upcoming, color: .orange),
                TimelineEvent(id: 4, date: "15 июля", title: "Крайний срок подачи", description: "Последний день приема документов", status: .deadline, color: .red),
                TimelineEvent(id: 5, date: "25 июля", title: "Объявление результатов", description: "Публикация списков зачисленных студентов", status: .upcoming, color: .purple)
            ]
        case 1: // Магистратура
            return [
                TimelineEvent(id: 1, date: "10 июня", title: "Начало приема", description: "Открыта подача документов в магистратуру", status: .completed, color: .green),
                TimelineEvent(id: 2, date: "20 июня", title: "Комплексное тестирование", description: "КТА и тестирование по специальности", status: .current, color: .blue),
                TimelineEvent(id: 3, date: "10 июля", title: "Собеседования", description: "Проведение собеседований с абитуриентами", status: .upcoming, color: .orange),
                TimelineEvent(id: 4, date: "20 июля", title: "Крайний срок подачи", description: "Последний день приема документов", status: .deadline, color: .red),
                TimelineEvent(id: 5, date: "30 июля", title: "Объявление результатов", description: "Публикация списков зачисленных", status: .upcoming, color: .purple)
            ]
        default: // Докторантура
            return [
                TimelineEvent(id: 1, date: "15 июня", title: "Начало приема", description: "Открыта подача документов в докторантуру", status: .completed, color: .green),
                TimelineEvent(id: 2, date: "25 июня", title: "Защита проектов", description: "Презентация исследовательских проектов", status: .current, color: .blue),
                TimelineEvent(id: 3, date: "15 июля", title: "Собеседования", description: "Индивидуальные собеседования с научными руководителями", status: .upcoming, color: .orange),
                TimelineEvent(id: 4, date: "25 июля", title: "Крайний срок подачи", description: "Последний день приема документов", status: .deadline, color: .red),
                TimelineEvent(id: 5, date: "5 августа", title: "Объявление результатов", description: "Публикация списков зачисленных", status: .upcoming, color: .purple)
            ]
        }
    }
}

// MARK: - Supporting Models and Views

struct TimelineEvent {
    let id: Int
    let date: String
    let title: String
    let description: String
    let status: EventStatus
    let color: Color
}

enum EventStatus {
    case completed, current, upcoming, deadline
    
    var icon: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .current: return "clock.circle.fill"
        case .upcoming: return "circle.dashed"
        case .deadline: return "exclamationmark.triangle.fill"
        }
    }
}

struct CountdownUnit: View {
    let value: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Text("\(value)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.indigo : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TimelineEventCard: View {
    let event: TimelineEvent
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                ZStack {
                    Circle()
                        .fill(event.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: event.status.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(event.color)
                }
                
                if event.id < 5 {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(event.date)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(event.color)
                    
                    Spacer()
                    
                    if event.status == .current {
                        Text("СЕЙЧАС")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                            )
                    }
                }
                
                Text(event.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(event.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct ImportantNoteCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
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
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    DeadlinesView()
}
