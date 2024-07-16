//
//  PatientDetailCard.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.
//
import SwiftUI
import PencilKit

struct PatientDetailCard: View {
    var patient: Patient
    @State private var showPencilKit = false
    @State private var canvasView = PKCanvasView()
    @State private var savedImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Display patient image if available
                if let imageURL = URL(string: patient.profileImage) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                        case .failure:
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                }
                
                VStack(alignment: .leading) {
                    Text(patient.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Pneumoniae")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Action for video call button
                    }) {
                        Image(systemName: "video")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    Button(action: {
                        // Action for phone call button
                    }) {
                        Image(systemName: "phone")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                // Additional patient details can go here
            }
            .font(.footnote)
            .foregroundColor(.gray)
            
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
    }
}
