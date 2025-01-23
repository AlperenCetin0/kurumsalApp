import SwiftUI

struct EmployeeProjectsView: View {
    let projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(projects) { project in
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 8, height: 8)
                    
                    Text(project.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(Int(project.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if projects.isEmpty {
                Text("Henüz proje atanmamış")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
            }
        }
    }
}
