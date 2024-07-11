import SwiftUI

// DoctorProfile
struct DoctorProfile {
    var id: String
    var idNumber: Int
    var name: String
    var contactNo: String
    var email: String
    var address: String
    var gender: String
    var dob: Date
    var degree: String
    var department: String
    var status: Bool
    var entryTime: Date
    var exitTime: Date
    var visitingFees: Int
    var imageURL: URL?
    var workingDays: [String]
    var yearsOfExperience: Int
}



struct DoctorProfileView: View {
    // Example DoctorProfile data
    @State private var doctorProfile = DoctorProfile(
        id: "123456",
        idNumber: 789012,
        name: "Dr. John Doe",
        contactNo: "123-456-7890",
        email: "dr.johndoe@example.com",
        address: "123 Main St, City, Country",
        gender: "Male",
        dob: Date(),
        degree: "MD, Cardiology",
        department: "Cardiology",
        status: true,
        entryTime: Date(),
        exitTime: Date(),
        visitingFees: 150,
        imageURL: nil,
        workingDays: ["Monday", "Wednesday", "Friday"],
        yearsOfExperience: 15
    )
    @State private var isEditing = false // Track edit mode
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text("Edit Profile")
                            .padding()
                            .background(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20) // Adjust spacing from the right edge
                    .padding(.top, 20) // Add top padding to separate from the title
                    .sheet(isPresented: $isEditing) {
                        DoctorEditProfileView(doctorProfile: $doctorProfile)
                    }
                }
                
                // Profile image and name centered
                VStack {
                    Image(systemName: "person.circle.fill") // Replace with actual profile image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .padding(.top)
                        .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                    
                    Text(doctorProfile.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .frame(maxWidth: 300)
                .padding(.bottom,20)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2) // Add shadow for depth
                
                Spacer(minLength: 30)
                
                // Profile details
                VStack {
                    ProfileRow(label: "ID Number", value: "\(doctorProfile.idNumber)")
                    Divider()
                    ProfileRow(label: "Contact No", value: doctorProfile.contactNo)
                    Divider()
                    ProfileRow(label: "Email", value: doctorProfile.email)
                    Divider()
                    ProfileRow(label: "Address", value: doctorProfile.address)
                    Divider()
                    ProfileRow(label: "Gender", value: doctorProfile.gender)
                    Divider()
                    ProfileRow(label: "DOB", value: DateFormatter.localizedString(from: doctorProfile.dob, dateStyle: .short, timeStyle: .none))
                    Divider()
                    ProfileRow(label: "Degree", value: doctorProfile.degree)
                    Divider()
                    ProfileRow(label: "Department", value: doctorProfile.department)
                    Divider()
                    ProfileRow(label: "Status", value: doctorProfile.status ? "Active" : "Inactive")
                    Divider()
                    ProfileRow(label: "Entry Time", value: DateFormatter.localizedString(from: doctorProfile.entryTime, dateStyle: .none, timeStyle: .short))
                    Divider()
                    ProfileRow(label: "Exit Time", value: DateFormatter.localizedString(from: doctorProfile.exitTime, dateStyle: .none, timeStyle: .short))
                    Divider()
                    ProfileRow(label: "Visiting Fees", value: "\(doctorProfile.visitingFees)")
                    Divider()
                    ProfileRow(label: "Years of Experience", value: "\(doctorProfile.yearsOfExperience) years")
                }
                
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2) // Add shadow for depth
                
                .padding(.bottom,120) // Add padding at the bottom of the additional content
                
                Spacer()
                                
                            
               
                
            }
            .padding()
            .background(Color(#colorLiteral(red: 0.968, green: 0.929, blue: 0.918, alpha: 1))) // Background color
            .navigationBarTitle("Doctor Profile", displayMode: .large)
        }
    }
}

struct ProfileRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
    }
}

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorProfileView()
    }
}




struct DoctorEditProfileView: View {
    @Binding var doctorProfile: DoctorProfile
    @Environment(\.presentationMode) var presentationMode // Environment variable to access the presentation mode

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Edit Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))

            // Editable fields
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $doctorProfile.name)
                    TextField("Contact No", text: $doctorProfile.contactNo)
                    TextField("Email", text: $doctorProfile.email)
                    TextField("Address", text: $doctorProfile.address)
                    TextField("Gender", text: $doctorProfile.gender)
                    DatePicker("DOB", selection: $doctorProfile.dob, displayedComponents: .date)
                }
                
                Section(header: Text("Professional Information")) {
                    TextField("Degree", text: $doctorProfile.degree)
                    TextField("Department", text: $doctorProfile.department)
                    TextField("Visiting Fees", value: $doctorProfile.visitingFees, formatter: NumberFormatter())
                    TextField("Years of Experience", value: $doctorProfile.yearsOfExperience, formatter: NumberFormatter())
                }
            }

            Spacer()

            // Save button
            Button(action: {
                // Handle save action
                presentationMode.wrappedValue.dismiss() // Dismiss the sheet
            }) {
                Text("Save")
                    .padding()
                    .background(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.968, green: 0.929, blue: 0.918, alpha: 1))) // Background color
    }
}







