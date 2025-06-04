//
//  Application.swift
//  UniStep
//
//  Created by Akberen Ualikhan on 01.06.2025.
//
import SwiftUI
import Foundation

// Модель заявки
struct Application: Identifiable {
    let id = UUID()
    let applicantName: String
    let programName: String
    let status: ApplicationStatus
    
    // Additional properties needed by HomeView
    let universityShortName: String
    let faculty: String
    let fullName: String
    let specialization: String
    let submissionDate: Date
    
    // Convenience initializer for backward compatibility
    init(applicantName: String, programName: String, status: ApplicationStatus, universityShortName: String = "МУИТ", faculty: String = "", specialization: String = "", submissionDate: Date = Date()) {
        self.applicantName = applicantName
        self.programName = programName
        self.status = status
        self.universityShortName = universityShortName
        self.faculty = faculty.isEmpty ? programName : faculty
        self.fullName = applicantName
        self.specialization = specialization.isEmpty ? programName : specialization
        self.submissionDate = submissionDate
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


// MARK: - Supporting Views

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

struct SuccessInfoRow: View {
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
            email: "aliya@example.com",
            applicationId: "AB2025-1234"
        )
    }
}

// MARK: - Supporting Views
struct SectionView<Content: View>: View {
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
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                content
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

enum DocumentStatus {
    case uploaded, pending, missing
    
    var color: Color {
        switch self {
        case .uploaded: return .green
        case .pending: return .orange
        case .missing: return .red
        }
    }
    
    var text: String {
        switch self {
        case .uploaded: return "Загружен"
        case .pending: return "Ожидание"
        case .missing: return "Отсутствует"
        }
    }
}

struct DocumentRow: View {
    let name: String
    let status: DocumentStatus
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(status.text)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(status.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(status.color.opacity(0.2))
                .cornerRadius(6)
        }
    }
}
