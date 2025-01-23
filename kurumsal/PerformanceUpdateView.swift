import SwiftUI

// Your imports remain the same

struct PerformanceUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EmployeeViewModel
    let employee: Employee
    
    @State private var newPerformanceRating: Int = 0 // Changed to Int
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Performans Değerlendirmesi")) {
                    Stepper("Performans: \(newPerformanceRating)", value: $newPerformanceRating, in: 1...5)
                    
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Button(action: {
                    var updatedEmployee = employee
                    updatedEmployee.performanceRating = Double(newPerformanceRating) // Convert Int to Double
                    viewModel.updateEmployee(updatedEmployee)
                    dismiss()
                }) {
                    Text("Kaydet")
                }
            }
            .navigationTitle("Performans Güncelle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}
