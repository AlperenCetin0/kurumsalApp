import SwiftUI

// Common card style modifier
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Stat card component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(CardStyle())
    }
}

// Department card component
struct DepartmentCard: View {
    let department: String
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(department)
                .font(.headline)
            Text("\(count) çalışan")
                .foregroundColor(.gray)
        }
        .frame(width: 150)
        .modifier(CardStyle())
    }
}

// Performance stats card component
struct PerformanceStatsCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text("\(count) çalışan")
                .foregroundColor(.gray)
        }
        .frame(width: 150)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// Activity row component
struct ActivityRow: View {
    let message: String
    let time: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
            Text(message)
                .foregroundColor(.gray)
            Spacer()
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

// Search bar component
struct CustomSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search projects"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}
