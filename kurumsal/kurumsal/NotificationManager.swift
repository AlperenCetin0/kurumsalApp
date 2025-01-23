import SwiftUI

// Notification types for different cases
enum NotificationType: Equatable {
    case performanceReview
    case vacationRequest
    case vacationApproval
    case newEmployee
    case custom(String)
    
    var icon: String {
        switch self {
        case .performanceReview: return "star.circle.fill"
        case .vacationRequest: return "calendar.badge.plus"
        case .vacationApproval: return "checkmark.circle.fill"
        case .newEmployee: return "person.badge.plus"
        case .custom: return "bell.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .performanceReview: return .yellow
        case .vacationRequest: return .blue
        case .vacationApproval: return .green
        case .newEmployee: return .purple
        case .custom: return .gray
        }
    }
}

// Notification model
struct AppNotification: Identifiable, Equatable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let employeeName: String
    let date: Date
    var isRead: Bool
    
    init(type: NotificationType, title: String, message: String, employeeName: String, date: Date = Date(), isRead: Bool = false) {
        self.type = type
        self.title = title
        self.message = message
        self.employeeName = employeeName
        self.date = date
        self.isRead = isRead
    }
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AppNotification, rhs: AppNotification) -> Bool {
        lhs.id == rhs.id
    }
}

// NotificationManager class to handle all notification operations
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [AppNotification] = []
    @Published var unreadCount: Int = 0
    
    private init() {
        loadSampleNotifications() // For testing
    }
    
    // Add a new notification
    func addNotification(type: NotificationType, title: String, message: String, employeeName: String) {
        let notification = AppNotification(
            type: type,
            title: title,
            message: message,
            employeeName: employeeName
        )
        notifications.insert(notification, at: 0)
        updateUnreadCount()
    }
    
    // Mark notification as read
    func markAsRead(_ notification: AppNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
            updateUnreadCount()
        }
    }
    
    // Mark all notifications as read
    func markAllAsRead() {
        notifications = notifications.map { notification in
            var updatedNotification = notification
            updatedNotification.isRead = true
            return updatedNotification
        }
        updateUnreadCount()
    }
    
    // Delete notification
    func deleteNotification(_ notification: AppNotification) {
        notifications.removeAll { $0.id == notification.id }
        updateUnreadCount()
    }
    
    // Update unread count
    private func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.isRead }.count
    }
    
    // Load sample notifications for testing
    private func loadSampleNotifications() {
        let sampleNotifications = [
            AppNotification(
                type: .performanceReview,
                title: "Performans Değerlendirmesi",
                message: "Performans değerlendirmesi zamanı geldi",
                employeeName: "Ahmet Yılmaz"
            ),
            AppNotification(
                type: .vacationRequest,
                title: "İzin Talebi",
                message: "5 günlük izin talep etti",
                employeeName: "Ayşe Kara",
                date: Date().addingTimeInterval(-3600)
            ),
            AppNotification(
                type: .newEmployee,
                title: "Yeni Çalışan",
                message: "Ekibe katıldı",
                employeeName: "Mehmet Demir",
                date: Date().addingTimeInterval(-7200)
            )
        ]
        
        notifications = sampleNotifications
        updateUnreadCount()
    }
}
