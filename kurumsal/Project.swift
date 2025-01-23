import Foundation

// Remove any existing Project.swift file from other locations
struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var startDate: Date
    var dueDate: Date
    var progress: Double // 0.0 to 1.0
    var tasks: [Task]
    var assignedEmployees: [UUID] // Employee IDs
    
    init(id: UUID = UUID(),
         name: String,
         description: String,
         startDate: Date,
         dueDate: Date,
         progress: Double = 0.0,
         tasks: [Task] = [],
         assignedEmployees: [UUID] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.dueDate = dueDate
        self.progress = progress
        self.tasks = tasks
        self.assignedEmployees = assignedEmployees
    }
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var status: TaskStatus
    var assignedTo: UUID? // Employee ID
    var dueDate: Date
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         status: TaskStatus = .pending,
         assignedTo: UUID? = nil,
         dueDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.assignedTo = assignedTo
        self.dueDate = dueDate
    }
}

enum TaskStatus: String, Codable {
    case notStarted = "Not Started"
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case delayed = "Delayed"
}
