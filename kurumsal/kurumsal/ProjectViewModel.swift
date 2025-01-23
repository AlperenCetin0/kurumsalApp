import Foundation

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var isLoading: Bool = false
    
    func addProject(_ project: Project) {
        projects.append(project)
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
        }
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
    }
    
    func addTaskToProject(_ task: Task, in project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            var updatedProject = project
            updatedProject.tasks.append(task)
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            projects[index] = updatedProject
        }
    }
    
    func updateTaskInProject(_ task: Task, in project: Project) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }),
           let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedProject = project
            updatedProject.tasks[taskIndex] = task
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            projects[projectIndex] = updatedProject
        }
    }
    
    func removeTaskFromProject(taskId: UUID, in project: Project) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            var updatedProject = project
            updatedProject.tasks.removeAll { $0.id == taskId }
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            projects[projectIndex] = updatedProject
        }
    }
    
    func updateTaskStatus(taskId: UUID, newStatus: TaskStatus, in project: Project) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }),
           let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == taskId }) {
            var updatedProject = project
            updatedProject.tasks[taskIndex].status = newStatus
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            projects[projectIndex] = updatedProject
        }
    }
    
    func calculateProjectProgress(for project: Project) -> Double {
        guard !project.tasks.isEmpty else { return 0.0 }
        let completedTasks = project.tasks.filter { $0.status == .completed }.count
        return Double(completedTasks) / Double(project.tasks.count)
    }
    
    func updateTaskStatus(in project: Project, taskId: UUID, newStatus: TaskStatus) {
        var updatedProject = project
        if let taskIndex = updatedProject.tasks.firstIndex(where: { $0.id == taskId }) {
            updatedProject.tasks[taskIndex].status = newStatus
            // Automatically update project progress
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            updateProject(updatedProject)
        }
    }
    
    func addTask(_ task: Task, to project: Project) {
        var updatedProject = project
        updatedProject.tasks.append(task)
        // Recalculate progress
        updatedProject.progress = calculateProjectProgress(for: updatedProject)
        updateProject(updatedProject)
    }
    
    func removeTask(withId taskId: UUID, from project: Project) {
        var updatedProject = project
        updatedProject.tasks.removeAll { $0.id == taskId }
        // Recalculate progress
        updatedProject.progress = calculateProjectProgress(for: updatedProject)
        updateProject(updatedProject)
    }
    
    func updateTask(_ updatedTask: Task, in project: Project) {
        var updatedProject = project
        if let taskIndex = updatedProject.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            updatedProject.tasks[taskIndex] = updatedTask
            // Recalculate progress
            updatedProject.progress = calculateProjectProgress(for: updatedProject)
            updateProject(updatedProject)
        }
    }
    
    func reassignTask(taskId: UUID, from oldEmployeeId: UUID?, to newEmployeeId: UUID, in project: Project) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }),
           let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == taskId }) {
            var updatedProject = project
            updatedProject.tasks[taskIndex].assignedTo = newEmployeeId
            projects[projectIndex] = updatedProject
        }
    }
    
    func handleEmployeeRemoval(employeeId: UUID, from project: Project) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            var updatedProject = project
            // Reset assignedTo for all tasks assigned to this employee
            for index in updatedProject.tasks.indices where updatedProject.tasks[index].assignedTo == employeeId {
                updatedProject.tasks[index].assignedTo = nil
                updatedProject.tasks[index].status = .pending
            }
            // Remove employee from project
            updatedProject.assignedEmployees.removeAll { $0 == employeeId }
            projects[projectIndex] = updatedProject
        }
    }
    
    func calculateEmployeeWorkload(employeeId: UUID) -> (total: Int, pending: Int, inProgress: Int) {
        var total = 0
        var pending = 0
        var inProgress = 0
        
        for project in projects {
            for task in project.tasks where task.assignedTo == employeeId {
                total += 1
                switch task.status {
                case .pending: pending += 1
                case .inProgress: inProgress += 1
                default: break
                }
            }
        }
        
        return (total, pending, inProgress)
    }
    
    func fetchProjects() {
        isLoading = true
        // Your existing fetch logic here
        // When done:
        isLoading = false
    }
}
