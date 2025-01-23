import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    let project: Project
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var assignedEmployeeId: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                // Here you would add employee selection
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let task = Task(
                            title: title,
                            description: description,
                            assignedTo: assignedEmployeeId,
                            dueDate: dueDate
                        )
                        viewModel.addTaskToProject(task, in: project)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}
