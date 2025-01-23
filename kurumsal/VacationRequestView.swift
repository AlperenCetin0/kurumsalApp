import SwiftUI

struct VacationRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EmployeeViewModel
    let employee: Employee
    @State private var requestedDays = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("İzin Talebi")) {
                    Stepper("Gün: \(requestedDays)", value: $requestedDays, in: 1...employee.remainingVacationDays)
                    Text("Kalan İzin: \(employee.remainingVacationDays) gün")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("İzin Talebi")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Onayla") {
                        var updatedEmployee = employee
                        updatedEmployee.remainingVacationDays -= requestedDays
                        viewModel.updateEmployee(updatedEmployee)
                        dismiss()
                    }
                    .disabled(requestedDays > employee.remainingVacationDays)
                }
            }
        }
    }
}

// End of file
