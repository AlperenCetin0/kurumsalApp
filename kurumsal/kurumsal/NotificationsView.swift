import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel: EmployeeViewModel
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notificationManager.notifications) { notification in
                    NotificationRow(notification: notification)
                        .listRowBackground(
                            notification.isRead ? Color.clear :
                                notification.type.color.opacity(0.1)
                        )
                        .onTapGesture {
                            notificationManager.markAsRead(notification)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                notificationManager.deleteNotification(notification)
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Bildirimler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !notificationManager.notifications.isEmpty {
                        Button("Tümünü Okundu İşaretle") {
                            notificationManager.markAllAsRead()
                        }
                    }
                }
            }
            .overlay {
                if notificationManager.notifications.isEmpty {
                    VStack {
                        Image(systemName: "bell.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Bildirim Yok")
                            .font(.headline)
                        Text("Yeni bildirimler geldiğinde burada görünecek")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: notification.type.icon)
                    .foregroundColor(notification.type.color)
                    .font(.title3)
                
                Text(notification.title)
                    .font(.headline)
                
                Spacer()
                
                if !notification.isRead {
                    Circle()
                        .fill(notification.type.color)
                        .frame(width: 8, height: 8)
                }
                
                Text(notification.date.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text(notification.employeeName)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(notification.date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
