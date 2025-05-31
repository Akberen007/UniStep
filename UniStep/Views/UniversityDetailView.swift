//
//  UniversityDetailView.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import SwiftUI

struct UniversityDetailView: View {
    let university: University
    @State private var selectedTab = 0
    @State private var showApplicationForm = false
    
    private let tabs = [
        TabItem(title: "Обзор", icon: "info.circle"),
        TabItem(title: "Факультеты", icon: "building.2"),
        TabItem(title: "Поступление", icon: "doc.text"),
        TabItem(title: "Контакты", icon: "phone")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                headerSection
                
                // Tab Navigation
                tabNavigation
                
                // Tab Content
                tabContent
                
                // Apply Button
                applyButton
                
                Spacer(minLength: 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showApplicationForm) {
            ApplicationFormView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            // University Image/Banner
            ZStack {
                LinearGradient(
                    colors: [university.color.opacity(0.8), university.color],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                
                VStack(spacing: 16) {
                    // University Logo
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: university.icon)
                            .font(.system(size: 35, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    // University Name
                    VStack(spacing: 4) {
                        Text(university.shortName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(university.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
            }
            
            // Quick Stats - Используем SimpleStatCard
            HStack(spacing: 0) {
                SimpleStatCard(
                    icon: "trophy.fill",
                    title: "Рейтинг",
                    value: "#\(university.ranking)",
                    color: .orange
                )
                
                Divider()
                    .frame(height: 40)
                
                SimpleStatCard(
                    icon: "person.2.fill",
                    title: "Студентов",
                    value: university.studentsCount,
                    color: .indigo
                )
                
                Divider()
                    .frame(height: 40)
                
                SimpleStatCard(
                    icon: "calendar.badge.plus",
                    title: "Основан",
                    value: "\(university.establishedYear)",
                    color: .teal
                )
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    // MARK: - Tab Navigation
    private var tabNavigation: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 18, weight: .medium))
                        
                        Text(tabs[index].title)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(selectedTab == index ? university.color : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Rectangle()
                            .fill(selectedTab == index ? university.color.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        Rectangle()
                            .fill(university.color)
                            .frame(height: 2)
                            .opacity(selectedTab == index ? 1 : 0),
                        alignment: .bottom
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color.white)
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
    
    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            overviewTab
        case 1:
            facultiesTab
        case 2:
            admissionTab
        case 3:
            contactsTab
        default:
            EmptyView()
        }
    }
    
    // MARK: - Overview Tab
    private var overviewTab: some View {
        VStack(spacing: 24) {
            // About Section
            InfoCard(
                icon: "info.circle.fill",
                title: "О университете",
                content: university.description,
                color: .cyan
            )
            
            // Type and Category
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Тип университета")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: university.type == .state ? "building.columns.fill" : "building.fill")
                            .foregroundColor(university.type.color)
                        Text(university.type.displayName)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Направление")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Text(university.category.displayName)
                            .font(.system(size: 16, weight: .medium))
                        Image(systemName: university.category.icon)
                            .foregroundColor(university.category.color)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            // Popular Faculties
            VStack(alignment: .leading, spacing: 16) {
                Text("Популярные факультеты")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(university.topFaculties, id: \.self) { faculty in
                        FacultyPreviewCard(name: faculty, color: university.color)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    // MARK: - Faculties Tab
    private var facultiesTab: some View {
        VStack(spacing: 16) {
            ForEach(university.topFaculties, id: \.self) { faculty in
                FacultyCard(
                    name: faculty,
                    description: "Факультет предлагает современные образовательные программы с практической направленностью.",
                    specialtiesCount: Int.random(in: 3...8),
                    color: university.color
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    // MARK: - Admission Tab
    private var admissionTab: some View {
        VStack(spacing: 24) {
            // Admission Requirements
            VStack(alignment: .leading, spacing: 16) {
                Text("Требования для поступления")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    AdmissionRequirementRow(
                        icon: "doc.text.fill",
                        title: "Вступительный экзамен",
                        value: university.admissionInfo.entranceExam,
                        color: .mint
                    )
                    
                    AdmissionRequirementRow(
                        icon: "target",
                        title: "Минимальный балл",
                        value: "\(university.admissionInfo.minScore)",
                        color: .orange
                    )
                    
                    AdmissionRequirementRow(
                        icon: "calendar.badge.clock",
                        title: "Срок подачи",
                        value: university.admissionInfo.documentsDeadline,
                        color: .red
                    )
                    
                    AdmissionRequirementRow(
                        icon: "dollarsign.circle.fill",
                        title: "Стоимость обучения",
                        value: university.admissionInfo.tuitionFee,
                        color: .green
                    )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    // MARK: - Contacts Tab
    private var contactsTab: some View {
        VStack(spacing: 24) {
            // Contact Information
            VStack(alignment: .leading, spacing: 16) {
                Text("Контактная информация")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    ContactRow(
                        icon: "location.fill",
                        title: "Адрес",
                        value: university.address,
                        color: .red
                    )
                    
                    ContactRow(
                        icon: "phone.fill",
                        title: "Телефон",
                        value: university.phone,
                        color: .green
                    )
                    
                    ContactRow(
                        icon: "envelope.fill",
                        title: "Email",
                        value: university.email,
                        color: .cyan
                    )
                    
                    ContactRow(
                        icon: "globe",
                        title: "Веб-сайт",
                        value: university.website,
                        color: .purple
                    )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            // Admission Contact
            VStack(alignment: .leading, spacing: 16) {
                Text("Приемная комиссия")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    ContactRow(
                        icon: "person.fill",
                        title: "Контактное лицо",
                        value: university.admissionInfo.contactPerson,
                        color: .indigo
                    )
                    
                    ContactRow(
                        icon: "phone.badge.plus",
                        title: "Телефон приемной",
                        value: university.admissionInfo.contactPhone,
                        color: .green
                    )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    // MARK: - Apply Button
    private var applyButton: some View {
        Button(action: {
            showApplicationForm = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "doc.fill")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Подать заявку в \(university.shortName)")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [university.color, university.color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: university.color.opacity(0.3), radius: 12, x: 0, y: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}

// MARK: - Supporting Views
struct TabItem {
    let title: String
    let icon: String
}

struct InfoCard: View {
    let icon: String
    let title: String
    let content: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct FacultyPreviewCard: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(16)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct FacultyCard: View {
    let name: String
    let description: String
    let specialtiesCount: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(description)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text("\(specialtiesCount) специальностей")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

struct AdmissionRequirementRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Простая карточка статистики для UniversityDetailView
struct SimpleStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    NavigationStack {
        UniversityDetailView(university: universitiesData[0])
    }
}
