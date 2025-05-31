import SwiftUI

struct UniversitiesCatalogView: View {
    var body: some View {
        List(universitiesData, id: \.shortName) { university in
            NavigationLink(destination: UniversityDetailView(university: university)) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(university.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: university.icon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(university.color)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(university.shortName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)

                        Text(university.name)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Каталог вузов")
    }
}

#Preview {
    NavigationStack {
        UniversitiesCatalogView()
    }
}
