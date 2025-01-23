import SwiftUI

struct DashboardView: View {
    // Properties
    @StateObject private var viewModel = EmployeeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Quick Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    DashboardCard(title: "Toplam Çalışan",
                                value: "\(viewModel.employees.count)",
                                icon: "person.3.fill",
                                color: .blue)
                    
                    DashboardCard(title: "Ortalama Performans",
                                value: String(format: "%.1f", viewModel.averagePerformance),
                                icon: "star.fill",
                                color: .yellow)
                }
                .padding(.horizontal)
                
                // Department Distribution Section
                VStack(alignment: .leading) {
                    Text("Departman Dağılımı")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.departmentStats, id: \.0) { dept in
                                DashboardCard(title: dept.department,
                                             value: "\(dept.count) çalışan",
                                             icon: "building.2",
                                             color: .blue)
                                    .frame(width: 150)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Performance Stats Section
                VStack(alignment: .leading) {
                    Text("Performans İstatistikleri")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            DashboardCard(title: "Yüksek Performans",
                                         value: "\(viewModel.employees.filter { $0.performanceRating >= 4 }.count)",
                                         icon: "star.fill",
                                         color: .green)
                                .frame(width: 150)
                            
                            DashboardCard(title: "Ortalama Performans",
                                         value: "\(viewModel.employees.filter { $0.performanceRating == 3 }.count)",
                                         icon: "star.fill",
                                         color: .blue)
                                .frame(width: 150)
                            
                            DashboardCard(title: "Düşük Performans",
                                         value: "\(viewModel.employees.filter { $0.performanceRating <= 2 }.count)",
                                         icon: "star.fill",
                                         color: .red)
                                .frame(width: 150)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Recent Activities Section
                VStack(alignment: .leading) {
                    Text("Son Aktiviteler")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        ForEach(1...5, id: \.self) { index in
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                Text("Yeni çalışan eklendi")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(index)s önce")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Dashboard")
    }
}

