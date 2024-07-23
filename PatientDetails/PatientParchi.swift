import SwiftUI
import PencilKit

struct PatientParchi: View {
    @StateObject var appModel = AppViewModel()
    var appointment: FirebaseAppointment
    @StateObject var documents = DocumentDataModel()
    
    @State private var navToMedReports = false
    @State private var navToLabReports = false
    
    @State private var isExpanded = false
    @State private var showPencilKit = false
    @State private var canvasView = PKCanvasView()
    @State private var savedImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Header with image and patient details
                HStack(alignment: .top) {
                    // Image
                    AsyncImage(url: URL(string: appModel.patientData[appointment.patientId]?.profileImage ?? "")) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .padding(.trailing, 20)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .padding(.trailing, 20)
                    }
              
                    // Name and Date
                    VStack(alignment: .leading) {
                        Text(appModel.patientData[appointment.patientId]?.name ?? "No name found")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                            .padding(.top,30)
                    }
                    Spacer()
                }
                
                
                // Buttons
                HStack(spacing: 10) {
                    NavigationLink(destination: PastMedicalReports(appointment: appointment), isActive: $navToMedReports) {
                        EmptyView()
                    }
                    Button(action: {
                        navToMedReports = true
                    }) {
                        Text("Medical Reports")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: PastLabReports(appointment: appointment), isActive: $navToLabReports) {
                        EmptyView()
                    }
                    Button(action: {
                        navToLabReports = true
                    }) {
                        Text("Lab Reports")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20)
                
                // Prescription section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Prescriptions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            showPencilKit.toggle()
                        }) {
                            HStack {
                                Text("Add")
                                Image(systemName: "pencil")
                            }
                            .font(.title3)
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .sheet(isPresented: $showPencilKit) {
                    PencilKitView(canvasView: $canvasView, onSave: { image in
                        savedImage = image
                        showPencilKit = false
                    })
                }
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            .navigationBarTitle("Patient Details", displayMode: .inline)
        }
    }
}
