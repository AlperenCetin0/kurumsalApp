import SwiftUI

struct ProjectsView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @EnvironmentObject var employeeViewModel: EmployeeViewModel
    @State private var showingAddProject = false
    @State private var projectToDelete: Project? = nil
    @State private var showingDeleteAlert = false
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case dueDate = "Due Date"
        case progress = "Progress"
    }
    
    var filteredAndSortedProjects: [Project] {
        let filtered = searchText.isEmpty ? viewModel.projects : viewModel.projects.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            switch SortOption.dueDate {
            case .name:
                return first.name < second.name
            case .dueDate:
                return first.dueDate < second.dueDate
            case .progress:
                return first.progress > second.progress
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchAndSortBar
                
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading projects...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if viewModel.projects.isEmpty {
                        EmptyProjectsView()
                    } else if filteredAndSortedProjects.isEmpty {
                        NoSearchResultsView(searchText: searchText)
                    } else {
                        List {
                            ForEach(filteredAndSortedProjects) { project in
                                NavigationLink(destination: ProjectDetailView(project: project, viewModel: viewModel)) {
                                    ProjectRow(project: project)
                                }
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first,
                                   let project = filteredAndSortedProjects[safe: index] {
                                    projectToDelete = project
                                    showingDeleteAlert = true
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProject = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProject) {
            AddProjectView(viewModel: viewModel)
        }
        .alert("Delete Project", isPresented: $showingDeleteAlert, presenting: projectToDelete) { project in
            Button("Delete", role: .destructive) {
                if let project = projectToDelete {
                    withAnimation {
                        viewModel.deleteProject(project)
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { project in
            Text("Are you sure you want to delete \(project.name)? This action cannot be undone.")
        }
        .tabItem {
            Image(systemName: "folder.fill")
            Text("Projects")
        }
    }
    
    private var searchAndSortBar: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search projects", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Picker("Sort by", selection: .constant(SortOption.dueDate)) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

struct ProjectRow: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 0) {
            // Project Name
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.system(.body, weight: .medium))
                Text(project.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Due Date
            Text(project.dueDate.formatted(.dateTime.day().month()))
                .font(.callout)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Progress
            HStack(spacing: 4) {
                ProgressView(value: project.progress)
                    .progressViewStyle(.linear)
                    .frame(width: 60)
                Text("\(Int(project.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(project.name)
                    .font(.headline)
                Spacer()
                StatusBadge(progress: project.progress)
            }
            
            Text(project.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            ProgressBar(value: project.progress)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text("Due: \(project.dueDate.formatted(.dateTime.day().month().year()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatusBadge: View {
    let progress: Double
    
    var body: some View {
        Text(statusText)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusText: String {
        switch progress {
        case 0: return "Not Started"
        case 1: return "Completed"
        default: return "\(Int(progress * 100))%"
        }
    }
    
    private var statusColor: Color {
        switch progress {
        case 0..<0.3: return .red
        case 0.3..<0.7: return .orange
        case 0.7..<1: return .blue
        default: return .green
        }
    }
}

struct ProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.3)
                    .foregroundColor(Color(.systemGray4))
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: 8)
                    .foregroundColor(progressColor(for: value))
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
    }
    
    private func progressColor(for value: Double) -> Color {
        switch value {
        case 0..<0.3: return .red
        case 0.3..<0.7: return .orange
        default: return .green
        }
    }
}

struct EmptyProjectsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No Projects")
                .font(.headline)
            Text("Tap + to create a new project")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
}

struct NoSearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No results for '\(searchText)'")
                .font(.headline)
            Text("Try different keywords or check your spelling")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
