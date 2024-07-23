import SwiftUI

struct PastMedicalReports: View {
    @StateObject var documents = DocumentDataModel()
    var appointment: FirebaseAppointment
    
    @State private var isLoading = true
    @State private var selectedImage: Photo? // Use the Photo struct here
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 15) // Adjust minimum size and spacing as needed
    ]
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) { // Adjust the spacing here
                        ForEach(documents.medRecords.filter { $0.type == "Medical Report" }) { record in
                            Button(action: {
                                selectedImage = Photo(id: record.id, url: record.image)
                            }) {
                                AsyncImage(url: URL(string: record.image)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150) // Adjust the size here
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 5)
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                        .frame(width: 150, height: 150) // Adjust the size here
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .sheet(item: $selectedImage) { photo in
                    ImagePreviewView(imageUrl: photo.url)
                }
            }
        }
        .onAppear {
            documents.fetchDocuments(appointment: appointment)
            isLoading = false // Set to false once documents are fetched
        }
        .navigationTitle("Medical Reports")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Photo: Identifiable {
    let id: String
    let url: String
}

import SwiftUI

struct ImagePreviewView: View {
    var imageUrl: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit() // Ensure the image scales to fit the view
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                   
            }
            .padding()
            
           
            
            Button(action: {
                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 20)
        }
        
        .edgesIgnoringSafeArea(.all)
    }
}
