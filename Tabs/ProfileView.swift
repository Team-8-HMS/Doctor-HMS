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
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        logOut()
                    }) {
                        Text("Log Out")
                            .padding()
                            .background(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                    }
                    .padding(.trailing, 20)
                    .padding(.top, -20)
                }
                
                // Profile image and name centered
                VStack {
                    if let selectedImage = selectedImage {
                        GeometryReader { geometry in
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 4)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(.white)
                                                .padding(15)
                                                .background(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 0.8)))
                                                .clipShape(Circle())
                                                .padding(.bottom)
                                                .offset(x: 80, y: 75)
                                        )
                                )
                                .shadow(radius: 10)
                                .padding(.top)
                                .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                        }
                        .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: "person.circle.fill") // Replace with actual profile image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.white)
                                            .padding(15)
                                            .background(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 0.8)))
                                            .clipShape(Circle())
                                            .padding(.bottom)
                                            .offset(x: 80, y: 75)
                                    )
                            )
                            .padding(.top)
                            .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }

                    Text(doctorProfile.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .frame(maxWidth: 200)
                .padding(.top, -20)
                
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
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                
                .padding(.bottom, 120) // Add padding at the bottom of the additional content
                
                Spacer()
            }
            .padding()
            .background(Color(#colorLiteral(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))) // Background color
            .navigationBarTitle("Doctor Profile", displayMode: .large)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func logOut() {
        // Implement your log out functionality here
        print("Log out action triggered")
    }
}

struct ProfileRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .frame(height: 40)
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
    }
}

// ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorProfileView()
    }
}
