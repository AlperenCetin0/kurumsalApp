import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    TextEditor(text: $description)
                        .frame(height: 100)
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let project = Project(
                            name: name,
                            description: description,
                            startDate: startDate,
                            dueDate: dueDate
                        )
                        viewModel.addProject(project)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
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

// End of file

