import Foundation

class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var searchText = ""
    @Published var selectedDepartmentFilter = "Tümü"
    @Published var showInactiveEmployees = false
    
    // Department list
    var departments: [String] {
        var depts = Set(["Tümü"] + employees.map { $0.department })
        return Array(depts).sorted()
    }
    
    // Filtered employees based on search
    var filteredEmployees: [Employee] {
        employees.filter { employee in
            let matchesSearch = searchText.isEmpty || 
                employee.name.localizedCaseInsensitiveContains(searchText) ||
                employee.department.localizedCaseInsensitiveContains(searchText)
            
            let matchesDepartment = selectedDepartmentFilter == "Tümü" || 
                employee.department == selectedDepartmentFilter
            
            let matchesStatus = showInactiveEmployees ? true : employee.isActive
            
            return matchesSearch && matchesDepartment && matchesStatus
        }
    }
    
    // Department statistics
    var departmentStats: [(department: String, count: Int)] {
        Dictionary(grouping: employees) { $0.department }
            .map { ($0.key, $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    // Performance statistics
    var averagePerformance: Double {
        let total = employees.reduce(0) { $0 + Double($1.performanceRating) }
        return total / Double(max(1, employees.count))
    }
    
    // CRUD Operations
    func addEmployee(_ employee: Employee) {
        employees.append(employee)
        NotificationManager.shared.addNotification(
            type: .newEmployee,
            title: "Yeni Çalışan",
            message: "Ekibe katıldı",
            employeeName: employee.name
        )
        objectWillChange.send()
    }
    
    func deleteEmployee(at offsets: IndexSet) {
        employees.remove(atOffsets: offsets)
        objectWillChange.send()
    }
    
    func updateEmployee(_ employee: Employee) {
        if let index = employees.firstIndex(where: { $0.id == employee.id }) {
            employees[index] = employee
            objectWillChange.send()
        }
    }
    
    // Load sample data
    func loadSampleData() {
        employees = [
            Employee.sampleEmployee,
            Employee(name: "Ayşe Kara", position: "İK Uzmanı", department: "İnsan Kaynakları", 
                    email: "ayse.kara@sirket.com", phone: "+90 550 618 68 22", startDate: Date()),
            Employee(name: "Mehmet Demir", position: "Proje Yöneticisi", department: "Yazılım",
                    email: "mehmet.demir@sirket.com", phone: "+90 535 663 33 76", startDate: Date()),
            Employee(name: "Elif Bozkurt", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "elif.bozkurt@sirket.com", phone: "+90 546 348 18 46", startDate: Date()),
            Employee(name: "Ayşegül Demir", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "aysegul.demir@sirket.com", phone: "+90 538 801 89 22", startDate: Date()),
            Employee(name: "Kübra Ünal", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "kubra.unal@sirket.com", phone: "+90 535 403 80 92", startDate: Date()),
            Employee(name: "Fadime Yüksel", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "fadime.yuksel@sirket.com", phone: "+90 539 214 72 22", startDate: Date()),
            Employee(name: "Hatice Acar", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "hatice.acar@sirket.com", phone: "+90 538 725 73 52", startDate: Date()),
            Employee(name: "Elif Ateş", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "elif.ates@sirket.com", phone: "+90 553 897 22 53", startDate: Date()),
            Employee(name: "Gülsüm Özdemir", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "gulsum.ozdemir@sirket.com", phone: "+90 536 556 23 24", startDate: Date()),
            Employee(name: "Hatice Yalçın", position: "İK Uzmanı", department: "İnsan Kaynakları",
                    email: "hatica.yalcin@sirket.com", phone: "+90 540 579 90 11", startDate: Date())
        ]
    }
}

extension EmployeeViewModel {
    // Function to send notifications
    func sendPerformanceNotification(for employee: Employee, message: String) {
        NotificationManager.shared.addNotification(
            type: .performanceReview,
            title: "Performans Değerlendirmesi",
            message: message,
            employeeName: employee.name
        )
    }
    
    func sendVacationRequestNotification(for employee: Employee, message: String) {
        NotificationManager.shared.addNotification(
            type: .vacationRequest,
            title: "İzin Talebi",
            message: message,
            employeeName: employee.name
        )
    }
    
    func sendVacationApprovalNotification(for employee: Employee, message: String) {
        NotificationManager.shared.addNotification(
            type: .vacationApproval,
            title: "İzin Onayı",
            message: message,
            employeeName: employee.name
        )
    }
    
    func sendCustomNotification(for employee: Employee, title: String, message: String) {
        NotificationManager.shared.addNotification(
            type: .custom(title),
            title: title,
            message: message,
            employeeName: employee.name
        )
    }
}
