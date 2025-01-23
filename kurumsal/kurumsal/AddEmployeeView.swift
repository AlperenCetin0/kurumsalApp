import SwiftUI

struct AddEmployeeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EmployeeViewModel
    
    @State private var name = ""
    @State private var position = ""
    @State private var department = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var startDate = Date()
    @State private var skills: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("İsim", text: $name)
                    TextField("Pozisyon", text: $position)
                    TextField("Departman", text: $department)
                }
                
                Section(header: Text("İletişim Bilgileri")) {
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Telefon", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("İş Bilgileri")) {
                    DatePicker("Başlangıç Tarihi", selection: $startDate, displayedComponents: .date)
                    TextField("Yetenekler (virgülle ayırın)", text: .constant(""))
                        .disabled(true)
                }
                
                Button(action: {
                    let skillsArray = skills
                    let newEmployee = Employee(
                        name: name,
                        position: position,
                        department: department,
                        email: email,
                        phone: phone,
                        startDate: startDate,
                        skills: skillsArray,
                        projectIds: [], 
                        notifications: []
                    )
                    viewModel.addEmployee(newEmployee)
                    dismiss()
                }) {
                    Text("Kaydet")
                }
                .disabled(name.isEmpty || position.isEmpty || department.isEmpty)
            }
            .navigationTitle("Yeni Çalışan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Çalışan Ekle") {
                        let employee = Employee(
                            name: name,
                            position: position,
                            department: department,
                            email: email,
                            phone: phone,
                            startDate: startDate,
                            skills: skills,
                            projectIds: [], 
                            notifications: []
                        )
                        viewModel.addEmployee(employee)
                        dismiss()
                    }
                    .disabled(name.isEmpty || position.isEmpty || department.isEmpty)
                }
            }
        }
    }
}
