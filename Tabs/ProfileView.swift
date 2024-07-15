import FirebaseFirestore
import Combine
import Foundation
import SwiftUI
import FirebaseAuth

class DoctorProfileFirestoreService: ObservableObject {
    @Published var doctorProfile: DoctorProfile?

    private var db = Firestore.firestore()

    func fetchCurrentUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let uid = user.uid
        db.collection("Doctors").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.doctorProfile = try document.data(as: DoctorProfile.self)
                } catch {
                    print("Error decoding document: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

    struct DoctorProfile: Identifiable, Codable {
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
    @StateObject private var firestoreService = DoctorProfileFirestoreService()
    @State private var isLoggedOut = false

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

                if let profile = firestoreService.doctorProfile {
                    VStack {
                        ProfileImageView(profile: profile)
                        ProfileDetailsView(profile: profile)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                } else {
                    Text("Loading profile...")
                }

                Spacer(minLength: 120)
            }
            NavigationLink(destination: LogInView(), isActive:$isLoggedOut){
                EmptyView()
            }
            .padding()
            .background(Color(#colorLiteral(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)))
            .navigationBarTitle("Doctor Profile", displayMode: .large)
        }
        .onAppear {
            firestoreService.fetchCurrentUserProfile()
        }
    }

    private func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
            print("Logged out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileImageView: View {
    let profile: DoctorProfile

    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let imageURL = profile.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 200)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 10)
                            .padding(.top)
                            .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                                                case .failure(_):
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2))
                            .padding(.top)
                            .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
                            
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4))
                    .padding(.top)
                    .foregroundColor(Color(#colorLiteral(red: 0.878, green: 0.365, blue: 0.29, alpha: 1)))
            }

            Text(profile.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, -20)
    }
}

struct ProfileDetailsView: View {
    let profile: DoctorProfile

    var body: some View {
        VStack {
            ProfileRow(label: "ID Number", value: "\(profile.idNumber)")
            Divider()
            ProfileRow(label: "Contact No", value: profile.contactNo)
            Divider()
            ProfileRow(label: "Email", value: profile.email)
            Divider()
            ProfileRow(label: "Address", value: profile.address)
            Divider()
            ProfileRow(label: "Gender", value: profile.gender)
            Divider()
            ProfileRow(label: "DOB", value: DateFormatter.localizedString(from: profile.dob, dateStyle: .short, timeStyle: .none))
            Divider()
            ProfileRow(label: "Degree", value: profile.degree)
            Divider()
            ProfileRow(label: "Department", value: profile.department)
            Divider()
            ProfileRow(label: "Status", value: profile.status ? "Active" : "Inactive")
            Divider()
            ProfileRow(label: "Entry Time", value: DateFormatter.localizedString(from: profile.entryTime, dateStyle: .none, timeStyle: .short))
            Divider()
            ProfileRow(label: "Exit Time", value: DateFormatter.localizedString(from: profile.exitTime, dateStyle: .none, timeStyle: .short))
            Divider()
            ProfileRow(label: "Visiting Fees", value: "\(profile.visitingFees)")
            Divider()
            ProfileRow(label: "Years of Experience", value: "\(profile.yearsOfExperience) years")
        }
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


    
    

