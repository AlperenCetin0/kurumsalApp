import Foundation

// Employee model definition
struct Employee: Identifiable, Codable {
    let id: UUID
    var name: String
    var position: String
    var department: String
    var email: String
    var phone: String
    var startDate: Date
    var isActive: Bool
    var performanceRating: Double
    var remainingVacationDays: Int
    var skills: [String]
    var projectIds: [UUID] 
    var notifications: [EmployeeNotification]

    init(id: UUID = UUID(),
         name: String,
         position: String,
         department: String,
         email: String,
         phone: String,
         startDate: Date,
         isActive: Bool = true,
         performanceRating: Double = 0.0,
         remainingVacationDays: Int = 20,
         skills: [String] = [],
         projectIds: [UUID] = [],
         notifications: [EmployeeNotification] = []) {
        self.id = id
        self.name = name
        self.position = position
        self.department = department
        self.email = email
        self.phone = phone
        self.startDate = startDate
        self.isActive = isActive
        self.performanceRating = performanceRating
        self.remainingVacationDays = remainingVacationDays
        self.skills = skills
        self.projectIds = projectIds
        self.notifications = notifications
    }

    // Sample data for preview
    static let sampleEmployee = Employee(
        name: "Ahmet Yılmaz",
        position: "Yazılım Geliştirici",
        department: "Bilgi Teknolojileri",
        email: "ahmet.yilmaz@sirket.com",
        phone: "0555-555-5555",
        startDate: Date(),
        skills: ["Swift", "SwiftUI", "iOS"],
        projectIds: [],
        notifications: [.init(title: "Toplantı", message: "Sprint Planning", date: Date())]
    )
}

// Notification model for employees
struct EmployeeNotification: Identifiable, Codable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var isRead: Bool

    init(id: UUID = UUID(),
         title: String,
         message: String,
         date: Date,
         isRead: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.isRead = isRead
    }
}


