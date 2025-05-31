//
//  UniversitiesCatalogView.swift
//  UniStep
//
//  Created by Akberen on 31.05.2025.
//

import SwiftUI

struct UniversitiesCatalogView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Все"
    
    let categories = ["Все", "Государственные", "Частные", "IT", "Медицинские", "Экономические", "Технические"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filters
            searchAndFiltersSection
            
            // Universities List
            universitiesList
        }
        .navigationTitle("Каталог университетов")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Search and Filters Section
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск университетов...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Universities List
    private var universitiesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredUniversities, id: \.name) { university in
                    NavigationLink(destination: UniversityDetailView(university: university)) {
                        UniversityCard(university: university)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Computed Properties
    private var filteredUniversities: [University] {
        let filtered = universitiesData.filter { university in
            // Category filter
            if selectedCategory != "Все" {
                switch selectedCategory {
                case "Государственные":
                    if university.type != .state { return false }
                case "Частные":
                    if university.type != .privateType { return false }
                case "IT":
                    if university.category != .it { return false }
                case "Медицинские":
                    if university.category != .medical { return false }
                case "Экономические":
                    if university.category != .economic { return false }
                case "Технические":
                    if university.category != .technical { return false }
                default:
                    break
                }
            }
            
            // Search filter
            if !searchText.isEmpty {
                return university.name.lowercased().contains(searchText.lowercased()) ||
                       university.shortName.lowercased().contains(searchText.lowercased())
            }
            
            return true
        }
        
        return filtered.sorted { $0.ranking < $1.ranking }
    }
}

// MARK: - University Card
struct UniversityCard: View {
    let university: University
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with image and basic info
            HStack(spacing: 16) {
                // University Logo/Image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(university.color.opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: university.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(university.color)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // University name and type
                    VStack(alignment: .leading, spacing: 4) {
                        Text(university.shortName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            TypeBadge(type: university.type)
                            CategoryBadge(category: university.category)
                        }
                    }
                    
                    // Location and stats
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(university.city)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text("\(university.studentsCount)")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                // Ranking
                VStack(spacing: 4) {
                    Text("#\(university.ranking)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("рейтинг")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            
            // Faculties preview
            if !university.topFaculties.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Популярные факультеты:")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(university.topFaculties.prefix(3), id: \.self) { faculty in
                                    Text(faculty)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(university.color)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(university.color.opacity(0.1))
                                        .cornerRadius(6)
                                }
                                
                                if university.topFaculties.count > 3 {
                                    Text("+\(university.topFaculties.count - 3)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Supporting Views
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.red : Color.white)
                )
                .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TypeBadge: View {
    let type: UniversityType
    
    var body: some View {
        Text(type.displayName)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(type.color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(type.color.opacity(0.15))
            .cornerRadius(4)
    }
}

struct CategoryBadge: View {
    let category: UniversityCategory
    
    var body: some View {
        Text(category.displayName)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.gray)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(4)
    }
}

#Preview {
    NavigationStack {
        UniversitiesCatalogView()
    }
}
