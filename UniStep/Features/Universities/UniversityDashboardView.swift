//  UniversityDashboardView.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import SwiftUI
import FirebaseFirestore

struct UniversityDashboardView: View {
    @EnvironmentObject private var authService: AuthService
    @StateObject private var applicationManager = UniversityAppDataManager()
    
    var body: some View {
        TabView {
            // ЗАЯВКИ
            NavigationView {
                UniversityApplicationsView()
                    .environmentObject(applicationManager)
            }
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Заявки")
            }
            
            // СТАТИСТИКА
            NavigationView {
                UniversityStatsView()
                    .environmentObject(applicationManager)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Статистика")
            }
            
            // ПРОФИЛЬ
            NavigationView {
                UniversityProfileView()
                    .environmentObject(authService)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Профиль")
            }
        }
        .accentColor(.orange)
        .onAppear {
            if let universityName = authService.currentUser?.universityName {
                applicationManager.loadApplicationsForUniversity(universityName)
            }
        }
    }
}

// MARK: - Applications View
struct UniversityApplicationsView: View {
    @EnvironmentObject private var applicationManager: UniversityAppDataManager
    @State private var selectedFilter: ApplicationStatusFilter = .allApps
    @State private var searchText = ""
    
    var filteredApplications: [UniversityApplicationData] {
        var apps = applicationManager.universityApps
        
        // Фильтр по статусу
        switch selectedFilter {
        case .allApps:
            break
        default:
            apps = apps.filter { $0.currentStatus == selectedFilter.rawValue }
        }
        
        // Поиск по имени
        if !searchText.isEmpty {
            apps = apps.filter {
                $0.studentFullName.lowercased().contains(searchText.lowercased()) ||
                $0.targetSpecialty.lowercased().contains(searchText.lowercased())
            }
        }
        
        return apps
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Поиск
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск по имени или специальности", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            // Фильтры
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ApplicationStatusFilter.allCases, id: \.self) { filter in
                        FilterChipView(
                            title: filter.displayText,
                            count: applicationManager.getAppCount(for: filter),
                            isSelected: selectedFilter == filter
                        ) {
                            selectedFilter = filter
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            
            // Список заявок
            if applicationManager.isLoadingData {
                Spacer()
                ProgressView("Загрузка заявок...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else if filteredApplications.isEmpty {
                UniversityEmptyView(filter: selectedFilter, hasSearch: !searchText.isEmpty)
            } else {
                List {
                    ForEach(filteredApplications) { app in
                        UniversityAppRowView(application: app)
                            .environmentObject(applicationManager)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    if let universityName = applicationManager.currentUniversityName {
                        applicationManager.loadApplicationsForUniversity(universityName)
                    }
                }
            }
        }
        .navigationTitle("Заявки (\(applicationManager.universityApps.count))")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Application Row View
struct UniversityAppRowView: View {
    let application: UniversityApplicationData
    @EnvironmentObject private var applicationManager: UniversityAppDataManager
    @State private var showDetails = false
    @State private var isProcessing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(application.studentFullName)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(application.targetSpecialty)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text(application.targetFaculty)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    UniversityStatusIndicator(status: application.currentStatus)
                    
                    Text(formatSubmissionDate(application.submittedAt))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            // Краткая информация
            HStack(spacing: 16) {
                UniversityInfoTag(icon: "phone", text: application.studentPhone)
                UniversityInfoTag(icon: "envelope", text: application.studentEmail)
                
                if let entScore = application.entScore, !entScore.isEmpty {
                    UniversityInfoTag(icon: "star.fill", text: "ЕНТ: \(entScore)")
                }
            }
            
            // Кнопки действий
            if application.currentStatus == "pending" && !isProcessing {
                HStack(spacing: 12) {
                    Button(action: {
                        updateStatus("rejected")
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Отклонить")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        updateStatus("accepted")
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Принять")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
            } else if isProcessing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Обновление статуса...")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onTapGesture {
            showDetails = true
        }
        .sheet(isPresented: $showDetails) {
            UniversityAppDetailView(application: application)
                .environmentObject(applicationManager)
        }
    }
    
    private func updateStatus(_ newStatus: String) {
        isProcessing = true
        
        applicationManager.updateApplicationStatus(
            appId: application.id,
            newStatus: newStatus
        ) { success in
            DispatchQueue.main.async {
                isProcessing = false
                if success {
                    // Показать успешное уведомление
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
        }
    }
    
    private func formatSubmissionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Statistics View
struct UniversityStatsView: View {
    @EnvironmentObject private var applicationManager: UniversityAppDataManager
    @StateObject private var dashboardData = DashboardDataModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Общая статистика
                UniversityStatsSection(title: "Общая статистика") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        UniversityStatCard(
                            title: "Всего заявок",
                            value: "\(applicationManager.universityApps.count)",
                            icon: "doc.text.fill",
                            color: .blue
                        )
                        
                        UniversityStatCard(
                            title: "Ожидают",
                            value: "\(applicationManager.getAppCount(for: .pendingApps))",
                            icon: "clock.fill",
                            color: .orange
                        )
                        
                        UniversityStatCard(
                            title: "Приняты",
                            value: "\(applicationManager.getAppCount(for: .acceptedApps))",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        UniversityStatCard(
                            title: "Отклонены",
                            value: "\(applicationManager.getAppCount(for: .rejectedApps))",
                            icon: "xmark.circle.fill",
                            color: .red
                        )
                    }
                }
                
                // Диаграмма заявок по времени
                if !applicationManager.universityApps.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Динамика подачи заявок")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        AnalyticsChartView(viewModel: dashboardData)
                            .frame(height: 250)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                }
                
                // Статистика по факультетам
                if !applicationManager.facultyStats.isEmpty {
                    UniversityStatsSection(title: "По факультетам") {
                        ForEach(applicationManager.facultyStats, id: \.facultyName) { stat in
                            UniversityFacultyRow(stat: stat)
                        }
                    }
                }
                
                // Популярные специальности
                if !applicationManager.specialtyStats.isEmpty {
                    UniversityStatsSection(title: "Популярные специальности") {
                        ForEach(Array(applicationManager.specialtyStats.prefix(5)), id: \.specialtyName) { stat in
                            UniversitySpecialtyRow(stat: stat)
                        }
                    }
                }
                
                // Недавние заявки
                if !applicationManager.universityApps.isEmpty {
                    UniversityStatsSection(title: "Недавние заявки") {
                        ForEach(Array(applicationManager.universityApps.prefix(3))) { app in
                            UniversityRecentAppRow(application: app)
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("Статистика")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            if let universityName = applicationManager.currentUniversityName {
                applicationManager.loadApplicationsForUniversity(universityName)
            }
        }
    }
}

// MARK: - App Detail View
struct UniversityAppDetailView: View {
    let application: UniversityApplicationData
    @EnvironmentObject private var applicationManager: UniversityAppDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showStatusChangeAlert = false
    @State private var pendingStatusChange = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок с именем
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.orange, .red]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                            
                            Text(getStudentInitials())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text(application.studentFullName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            UniversityStatusIndicator(status: application.currentStatus)
                        }
                    }
                    
                    // Основная информация
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.orange)
                            Text("Контактная информация")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Email", value: application.studentEmail, icon: "envelope.fill")
                            DetailRow(title: "Телефон", value: application.phoneFormatted, icon: "phone.fill")
                            DetailRow(title: "Город", value: application.studentCity, icon: "location.fill")
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // Образование
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "graduationcap.circle.fill")
                                .foregroundColor(.orange)
                            Text("Образование")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Школа", value: application.studentSchool, icon: "building.columns.fill")
                            if let entScore = application.entScore, !entScore.isEmpty {
                                DetailRow(title: "Балл ЕНТ", value: entScore, icon: "star.fill")
                            }
                            if let avgGrade = application.avgGrade, !avgGrade.isEmpty {
                                DetailRow(title: "Средний балл", value: avgGrade, icon: "chart.bar.fill")
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // Выбор специальности
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "book.circle.fill")
                                .foregroundColor(.orange)
                            Text("Специальность")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Университет", value: application.targetUniversity, icon: "building.2.fill")
                            DetailRow(title: "Факультет", value: application.targetFaculty, icon: "building.fill")
                            DetailRow(title: "Специальность", value: application.targetSpecialty, icon: "bookmark.fill")
                            DetailRow(title: "Язык обучения", value: application.studyLanguage, icon: "globe")
                            DetailRow(title: "Форма обучения", value: application.studyForm, icon: "calendar")
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // Дата подачи
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "clock.circle.fill")
                                .foregroundColor(.orange)
                            Text("Информация о заявке")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Дата подачи", value: formatDetailDate(application.submittedAt), icon: "calendar.badge.clock")
                            DetailRow(title: "ID заявки", value: application.id, icon: "number.circle.fill")
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // Кнопки действий
                    if application.currentStatus == "pending" && !isProcessing {
                        VStack(spacing: 12) {
                            Button(action: {
                                pendingStatusChange = "accepted"
                                showStatusChangeAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Принять заявку")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                pendingStatusChange = "rejected"
                                showStatusChangeAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Отклонить заявку")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red)
                                .cornerRadius(12)
                            }
                        }
                    } else if isProcessing {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Обновление статуса...")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Детали заявки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .alert("Изменение статуса", isPresented: $showStatusChangeAlert) {
                Button("Отмена", role: .cancel) { }
                Button(pendingStatusChange == "accepted" ? "Принять" : "Отклонить") {
                    updateStatus(pendingStatusChange)
                }
            } message: {
                Text(pendingStatusChange == "accepted" ?
                     "Вы уверены, что хотите принять эту заявку?" :
                     "Вы уверены, что хотите отклонить эту заявку?")
            }
        }
    }
    
    private func updateStatus(_ newStatus: String) {
        isProcessing = true
        
        applicationManager.updateApplicationStatus(
            appId: application.id,
            newStatus: newStatus
        ) { success in
            DispatchQueue.main.async {
                isProcessing = false
                if success {
                    dismiss()
                }
            }
        }
    }
    
    private func getStudentInitials() -> String {
        let components = application.studentFullName.components(separatedBy: " ")
        if components.count >= 2 {
            let first = String(components[0].prefix(1))
            let second = String(components[1].prefix(1))
            return "\(first)\(second)"
        } else {
            return String(application.studentFullName.prefix(2))
        }
    }
    
    private func formatDetailDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

// MARK: - Detail Row Helper
struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .medium))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
