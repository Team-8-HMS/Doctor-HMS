import Foundation
import SwiftUI
import PencilKit

struct DoctorNotesView: View {
    @State private var showPencilKit = false
    @State private var showUploadButton = false
    @State private var canvasView = PKCanvasView()
    @State private var noteImage: UIImage? = nil
    @State private var currentSection: Section? = nil

    enum Section {
        case medicalRecords, labTests, prescriptions
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Mary Chris")
                        .font(.headline)
                    Text("Age: 20")
                    Text("Gender: Female")
                    Text("Contact Number: 7983175620")
                    Text("Allergies: allergy")
                }
                Spacer()
                Button(action: {
                    showPencilKit.toggle()
                }) {
                    Text("Add Notes")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            Spacer()

            SectionRow(title: "Medical Records", action: {
                currentSection = .medicalRecords
                showUploadButton.toggle()
            })
            if currentSection == .medicalRecords {
                Button(action: {
                    showPencilKit.toggle()
                }) {
                    Text("Upload Files")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }
            }

            if currentSection == .medicalRecords, let noteImage = noteImage {
                Image(uiImage: noteImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            SectionRow(title: "Lab Test", action: {
                currentSection = .labTests
                showUploadButton.toggle()
            })
            if currentSection == .labTests {
                Button(action: {
                    showPencilKit.toggle()
                }) {
                    Text("Upload Files")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }
            }

            SectionRow(title: "Prescriptions", action: {
                currentSection = .prescriptions
                showUploadButton.toggle()
            })
            if currentSection == .prescriptions {
                Button(action: {
                    showPencilKit.toggle()
                }) {
                    Text("Upload Files")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }
            }

            Spacer()
        }
        .sheet(isPresented: $showPencilKit) {
            PencilKitView(canvasView: $canvasView, onSave: { image in
                noteImage = image
                showPencilKit = false
                saveImage(image, for: currentSection)
            })
            .edgesIgnoringSafeArea(.all)
        }
    }

    // Function to save the image with date for the appropriate section
    private func saveImage(_ image: UIImage, for section: Section?) {
        guard section != nil else { return }
        _ = Date()
        // Save the image with the date to the appropriate section
        // This can be done by saving to a local file or database
        // Example: save to UserDefaults or a file system with the section and date as keys
    }
}

struct SectionRow: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding([.leading, .trailing])
            
        }
    }
}

struct DoctorNotesView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorNotesView()
    }
}
