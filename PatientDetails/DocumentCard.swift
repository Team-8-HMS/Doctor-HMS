//
//  DocumentCard.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.
//
import SwiftUI
struct DocumentCard: View {
    @State var documents: [labTest]
    @State private var isExpanded = false
    @State private var showingDocumentPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Lab Test")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showingDocumentPicker = true
                }) {
                    Text("Add Files")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingDocumentPicker) {
                    DocumentPicker { urls in
                        for url in urls {
                            let newDocument = labTest(name: url.lastPathComponent)
                            documents.append(newDocument)
                        }
                    }
                }
            }
            ForEach(isExpanded ? documents : Array(documents.prefix(3))) { document in
                Divider()
                HStack {
                    Text(document.name)
                    
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        // Handle file download here
                        print("Download file: \(document.name)")
                        
                    }) {
                        Image(systemName: "arrow.down.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            Button(action: {
                isExpanded.toggle()
                
            }) {
                Text(isExpanded ? "Hide" : "See All")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
