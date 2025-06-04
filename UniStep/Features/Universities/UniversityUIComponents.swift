//
//  UniversityUIComponents.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 02.06.2025.
//

import SwiftUI

// MARK: - Filter Chip View
struct FilterChipView: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isSelected ? .white : .orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.white.opacity(0.3) : Color.orange.opacity(0.2))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.orange : Color.white)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Status Indicator
struct UniversityStatusIndicator: View {
    let status: String
    
    var statusConfig: (color: Color, text: String, icon: String) {
        switch status {
        case "pending":
            return (.orange, "Ожидает", "clock.fill")
        case "accepted":
            return (.green, "Принят", "checkmark.circle.fill")
        case "rejected":
            return (.red, "Отклонен", "xmark.circle.fill")
        case "awaiting_docs":
            return (.blue, "Ожидание документов", "doc.fill")
        default:
            return (.gray, "Неизвестно", "questionmark.circle.fill")
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: statusConfig.icon)
                .font(.system(size: 10))
            Text(statusConfig.text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(statusConfig.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusConfig.color.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - Info Tag
struct UniversityInfoTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color(.systemGray6))
        .cornerRadius(4)
    }
}

// MARK: - Empty State View
struct UniversityEmptyView: View {
    let filter: ApplicationStatusFilter
    let hasSearch: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasSearch ? "magnifyingglass" : "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 4) {
                Text(hasSearch ? "Ничего не найдено" : "Нет заявок")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var emptyMessage: String {
        if hasSearch {
            return "Попробуйте изменить поисковый запрос"
        }
        
        switch filter {
        case .allApps:
            return "Пока нет поданных заявок в ваш университет"
        case .pendingApps:
            return "Нет заявок, ожидающих рассмотрения"
        case .acceptedApps:
            return "Нет принятых заявок"
        case .rejectedApps:
            return "Нет отклоненных заявок"
        case .awaitingDocsApps:
            return "Нет заявок, ожидающих документы"
        }
    }
}

// MARK: - Stat Card
struct UniversityStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Stats Section
struct UniversityStatsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            content
        }
    }
}

// MARK: - Faculty Row
struct UniversityFacultyRow: View {
    let stat: UniversityFacultyStat
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stat.facultyName)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    UniversityStatBadge(title: "Всего", count: stat.totalApps, color: .blue)
                    UniversityStatBadge(title: "Ожидают", count: stat.pendingApps, color: .orange)
                    UniversityStatBadge(title: "Приняты", count: stat.acceptedApps, color: .green)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Specialty Row
struct UniversitySpecialtyRow: View {
    let stat: UniversitySpecialtyStat
    
    var body: some View {
        HStack {
            Text(stat.specialtyName)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
            
            Spacer()
            
            Text("\(stat.appCount)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.orange)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Stat Badge
struct UniversityStatBadge: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Recent App Row
struct UniversityRecentAppRow: View {
    let application: UniversityApplicationData
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(application.studentFullName)
                    .font(.system(size: 14, weight: .medium))
                
                Text(application.targetSpecialty)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                UniversityStatusIndicator(status: application.currentStatus)
                
                Text(timeAgoSince(application.submittedAt))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func timeAgoSince(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
