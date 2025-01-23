//
//  ContentView.swift
//  kurumsal
//
//  Created by Alperen Çetin on 8.01.2025.
//

import SwiftUI

// Main content view for the employee management system
struct ContentView: View {
    @StateObject private var employeeViewModel = EmployeeViewModel()
    @StateObject private var projectViewModel = ProjectViewModel()
    
    var body: some View {
        TabView {
            // Use single NavigationView for Employees
            NavigationStack {
                EmployeeListView(viewModel: employeeViewModel, projectViewModel: projectViewModel)
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Çalışanlar")
            }
            
            NavigationStack {
                DashboardSection(viewModel: employeeViewModel)
            }
            .tabItem {
                Image(systemName: "chart.pie.fill")
                Text("Dashboard")
            }
            
            NavigationStack {
                NotificationsView(viewModel: employeeViewModel)
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Bildirimler")
            }
            
            // Use single NavigationView for Projects
            NavigationStack {
                ProjectsView(viewModel: projectViewModel)
            }
            .tabItem {
                Image(systemName: "folder.fill")
                Text("Projeler")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Ayarlar")
            }
        }
        .environmentObject(employeeViewModel)
        .accentColor(.blue)
        .onAppear {
            employeeViewModel.loadSampleData()
        }
    }
}

// Employee list view component
struct EmployeeListView: View {
    @ObservedObject var viewModel: EmployeeViewModel
    @ObservedObject var projectViewModel: ProjectViewModel
    @State private var showingAddEmployee = false
    
    var body: some View {
        List {
            // Department filter
            Picker("Departman", selection: $viewModel.selectedDepartmentFilter) {
                ForEach(viewModel.departments, id: \.self) { department in
                    Text(department).tag(department)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .listRowBackground(Color.blue.opacity(0.1))
            
            // Search bar
            SearchBar(text: $viewModel.searchText)
                .listRowBackground(Color.blue.opacity(0.1))
            
            // Employee list
            ForEach(viewModel.filteredEmployees) { employee in
                NavigationLink(destination: EmployeeDetailView(viewModel: viewModel, projectViewModel: projectViewModel, employee: employee)) {
                    ModernEmployeeRow(employee: employee)
                }
            }
            .onDelete(perform: viewModel.deleteEmployee)
        }
        .navigationTitle("Çalışanlar")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddEmployee = true }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingAddEmployee) {
            AddEmployeeView(viewModel: viewModel)
        }
    }
}

// Search bar view component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Ara...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

// Dashboard section to avoid naming conflicts
struct DashboardSection: View {
    @ObservedObject var viewModel: EmployeeViewModel
    
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
                
                // Department Distribution
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
                
                // Performance Stats
                VStack(alignment: .leading) {
                    Text("Performans İstatistikleri")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            DashboardCard(title: "Yüksek",
                                         value: "\(viewModel.employees.filter { $0.performanceRating >= 4 }.count)",
                                         icon: "star.fill",
                                         color: .green)
                                .frame(width: 150)
                            
                            DashboardCard(title: "Ortalama",
                                         value: "\(viewModel.employees.filter { $0.performanceRating == 3 }.count)",
                                         icon: "star.fill",
                                         color: .blue)
                                .frame(width: 150)
                            
                            DashboardCard(title: "Düşük",
                                         value: "\(viewModel.employees.filter { $0.performanceRating <= 2 }.count)",
                                         icon: "star.fill",
                                         color: .red)
                                .frame(width: 150)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Activities
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

// Dashboard card component
struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Settings view component
struct SettingsView: View {
    var body: some View {
        Text("Ayarlar - Yakında")
    }
}

// Modern employee row view component
struct ModernEmployeeRow: View {
    let employee: Employee
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image or Initial
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(employee.name.prefix(1))
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.name)
                    .font(.headline)
                
                Text(employee.position)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.blue)
                        .imageScale(.small)
                    Text(employee.department)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Performance indicator
            if employee.performanceRating > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<Int(employee.performanceRating), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .imageScale(.small)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
