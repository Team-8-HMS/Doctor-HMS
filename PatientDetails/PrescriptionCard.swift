//
//  PrescriptionCard.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.

import SwiftUI
import PencilKit

struct PrescriptionCard: View {
    var prescriptions: [Prescription]
    @State private var isExpanded = false
    @State private var showPencilKit = false
    @State private var canvasView = PKCanvasView()
    @State private var savedImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Prescriptions")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    showPencilKit.toggle()
                }) {
                    Text("Add")
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            
            ForEach(isExpanded ? prescriptions : Array(prescriptions.prefix(3))) { prescription in
                Divider()
                HStack {
                    Text(prescription.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        // Handle prescription details here
                        print("View details of: \(prescription.name)")
                    }) {
                        Image(systemName: "info.circle")
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
        .sheet(isPresented: $showPencilKit) {
            PencilKitView(canvasView: $canvasView, onSave: { image in
                savedImage = image
                showPencilKit = false
            })
        }
    }
}
