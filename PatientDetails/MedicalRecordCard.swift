//
//  MedicalRecordCard.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.
//
import SwiftUI

struct MedicalRecordRow: View {
    var record: MedicalRecord

    var body: some View {
        HStack {
            Text(record.date)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(record.symptoms)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(record.specialist)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                // Handle file download here
                print("Download file from \(record.fileURL)")
            }) {
                Image(systemName: "arrow.down.circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct MedicalRecordsList: View {
    @State var records: [MedicalRecord]
    @State private var isExpanded = false
    @State private var showingDocumentPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Medical Records")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showingDocumentPicker = true
                }) {
                    Text("Add Record")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingDocumentPicker) {
                    DocumentPicker { urls in
                        for url in urls {
                            let newRecord = MedicalRecord(
                                date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short),
                                symptoms: "Unknown",
                                specialist: "Unknown",
                                fileURL: url
                            )
                            records.append(newRecord)
                        }
                    }
                }
            }
            if isExpanded {
                ForEach(records) { record in
                    VStack {
                        MedicalRecordRow(record: record)
                        Divider()
                    }
                }
            } else {
                ForEach(records.prefix(3)) { record in
                    VStack {
                        MedicalRecordRow(record: record)
                        Divider()
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
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
