import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    @ObservedObject var viewModel: ProjectViewModel
    @EnvironmentObject var employeeViewModel: EmployeeViewModel 
    @State private var showingAddTask = false
    @State private var showingAddEmployee = false
    
    var assignedEmployees: [Employee] {
        project.assignedEmployees.compactMap { employeeId in
            employeeViewModel.employees.first { $0.id == employeeId }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Project Details Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("PROJECT DETAILS")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(project.description)
                            .font(.body)
                        
                        ProgressSection(progress: project.progress)
                        
                        DateSection(title: "Start Date", date: project.startDate)
                        DateSection(title: "Due Date", date: project.dueDate)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                
                // Tasks Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("TASKS")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                        Button(action: { showingAddTask = true }) {
                            Label("Add Task", systemImage: "plus.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.system(.title3))
                        }
                    }
                    
                    if project.tasks.isEmpty {
                        EmptyTasksView()
                    } else {
                        TasksList(tasks: project.tasks)
                    }
                }
                
                // Team Members Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("ASSIGNED TEAM MEMBERS")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                        Button(action: { showingAddEmployee = true }) {
                            Label("Add Employee", systemImage: "plus.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.system(.title3))
                        }
                    }
                    
                    if assignedEmployees.isEmpty {
                        EmptyTeamView()
                    } else {
                        TeamMembersList(members: assignedEmployees)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(project: project, viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddEmployee) {
            SelectEmployeeView(project: project, viewModel: viewModel)
        }
    }
    
    private func removeEmployee(_ employee: Employee) {
        var updatedProject = project
        updatedProject.assignedEmployees.removeAll { $0 == employee.id }
        viewModel.updateProject(updatedProject)
        
        // Update employee's projects
        var updatedEmployee = employee
        updatedEmployee.projectIds.removeAll { $0 == project.id }
        employeeViewModel.updateEmployee(updatedEmployee)
    }
}

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        TaskRow(task: task)
    }
}

struct SelectEmployeeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var employeeViewModel: EmployeeViewModel
    let project: Project
    @ObservedObject var viewModel: ProjectViewModel
    
    var availableEmployees: [Employee] {
        employeeViewModel.employees.filter { employee in
            !project.assignedEmployees.contains(employee.id)
        }
    }
    
    var body: some View {
        NavigationView {
            List(availableEmployees) { employee in
                Button(action: {
                    assignEmployee(employee)
                    dismiss()
                }) {
                    HStack {
                        Text(employee.name)
                        Spacer()
                        Text(employee.position)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Select Employee")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func assignEmployee(_ employee: Employee) {
        // Update project
        var updatedProject = project
        updatedProject.assignedEmployees.append(employee.id)
        viewModel.updateProject(updatedProject)
        
        // Update employee
        var updatedEmployee = employee
        updatedEmployee.projectIds.append(project.id)
        employeeViewModel.updateEmployee(updatedEmployee)
    }
}

// MARK: - Supporting Views
struct ProgressSection: View {
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress:")
                    .fontWeight(.medium)
                Spacer()
                ProjectProgressBadge(progress: progress)
            }
            
            ProgressView(value: progress)
                .tint(progressColor)
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.3: return .red
        case 0.3..<0.7: return .orange
        case 0.7...1.0: return .green
        default: return .gray
        }
    }
}

struct DateSection: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(date.formatted(.dateTime.day().month().year().hour().minute()))
                .foregroundColor(.secondary)
        }
    }
}

struct TasksList: View {
    let tasks: [Task]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(tasks) { task in
                TaskRow(task: task)
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                Text("Due: \(task.dueDate.formatted(.dateTime.month().day()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            TaskStatusBadge(status: task.status)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct TaskStatusBadge: View {
    let status: TaskStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch status {
        case .notStarted:
            return .gray
        case .pending:
            return .orange
        case .inProgress:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .red
        case .delayed:
            return .purple
        }
    }
}

struct TeamMembersList: View {
    let members: [Employee]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(members) { member in
                MemberRow(member: member)
            }
        }
    }
}

struct MemberRow: View {
    let member: Employee
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.body)
                Text(member.position)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct EmptyTasksView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("No tasks added yet")
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct EmptyTeamView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("No team members assigned")
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct ProjectProgressBadge: View {
    let progress: Double
    
    var body: some View {
        Text(progressText)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(progressColor.opacity(0.2))
            .foregroundColor(progressColor)
            .cornerRadius(8)
    }
    
    private var progressText: String {
        "\(Int(progress * 100))%"
    }
    
    private var progressColor: Color {
        switch progress {
        case 0: return .red
        case 0..<0.3: return .red
        case 0.3..<0.7: return .orange
        case 0.7..<1.0: return .blue
        case 1.0: return .green
        default: return .gray
        }
    }
}
