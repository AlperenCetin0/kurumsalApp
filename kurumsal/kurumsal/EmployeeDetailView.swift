import SwiftUI

struct EmployeeDetailView: View {
    @ObservedObject var viewModel: EmployeeViewModel
    @ObservedObject var projectViewModel: ProjectViewModel
    let employee: Employee
    @State private var showingPerformanceSheet = false
    @State private var showingVacationSheet = false
    
    var employeeProjects: [Project] {
        employee.projectIds.compactMap { projectId in
            projectViewModel.projects.first { $0.id == projectId }
        }
    }
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 24) {
                    ProfileHeader(employee: employee)
                        .padding(.top)
                        .listRowInsets(EdgeInsets()) // Remove default list row padding
                    
                    HStack(spacing: 20) {
                        Button(action: { showingPerformanceSheet = true }) {
                            ActionButtonContent(title: "Performans", icon: "chart.bar.fill")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: { showingVacationSheet = true }) {
                            ActionButtonContent(title: "İzin", icon: "calendar")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    StatsView(employee: employee)
                    
                    VStack(spacing: 16) {
                        DetailSection(title: "Kişisel Bilgiler", icon: "person.text.rectangle") {
                            InfoRow(icon: "person.fill", title: "İsim", value: employee.name)
                            InfoRow(icon: "briefcase.fill", title: "Pozisyon", value: employee.position)
                            InfoRow(icon: "building.2.fill", title: "Departman", value: employee.department)
                        }
                        
                        DetailSection(title: "İletişim", icon: "envelope.circle.fill") {
                            InfoRow(icon: "envelope.fill", title: "Email", value: employee.email)
                            InfoRow(icon: "phone.fill", title: "Telefon", value: employee.phone)
                        }
                        
                        DetailSection(title: "Yetenekler", icon: "star.circle.fill") {
                            SkillsView(skills: employee.skills)
                        }
                        
                        DetailSection(title: "Projeler", icon: "folder.circle.fill") {
                            EmployeeProjectsView(projects: employeeProjects)
                        }
                        
                        DetailSection(title: "İş Bilgileri", icon: "building.columns.circle.fill") {
                            InfoRow(icon: "calendar", title: "Başlangıç Tarihi", value: employee.startDate.formatted(date: .long, time: .omitted))
                            InfoRow(icon: "checkmark.circle.fill", title: "Durum", value: employee.isActive ? "Aktif" : "Pasif")
                        }
                    }
                }
                .padding()
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle()) // Use plain style to remove default list styling
        .navigationTitle(employee.name)
        .navigationBarTitleDisplayMode(.large) // This will keep the title fixed
        .sheet(isPresented: $showingPerformanceSheet) {
            PerformanceUpdateView(viewModel: viewModel, employee: employee)
        }
        .sheet(isPresented: $showingVacationSheet) {
            VacationRequestView(viewModel: viewModel, employee: employee)
        }
    }
}

struct ProfileHeader: View {
    let employee: Employee
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.7), .blue.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Text(employee.name.prefix(1))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(radius: 5)
            
            VStack(spacing: 8) {
                Text(employee.name)
                    .font(.title)
                    .bold()
                
                Text(employee.position)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct StatsView: View {
    let employee: Employee
    
    var body: some View {
        HStack(spacing: 20) {
            StatCard(title: "Performans",
                    value: "\(employee.performanceRating)/5",
                    icon: "star.fill",
                    color: .orange)
            
            StatCard(title: "Kalan İzin",
                    value: "\(employee.remainingVacationDays)",
                    icon: "calendar",
                    color: .green)
        }
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.title3)
                    .bold()
            }
            
            content
                .padding(.leading, 8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .bold()
        }
    }
}

struct ActionButtonContent: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
            
            Text(title)
                .font(.headline)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.6)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .foregroundColor(.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}
