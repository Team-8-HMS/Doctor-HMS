//
//  MedReports.swift
//  Doctor-HMS
//
//  Created by Sudhanshu Singh Rajput on 18/07/24.
//

import SwiftUI

struct MedReports: View {
    @StateObject var documents = DocumentDataModel()
    var appointment: FirebaseAppointment
    @State private var isLoading = true
    @State private var fetchError: Error?
    
    var body: some View {
        List{
            Section(header: Text("Medical Reports")) {
                ForEach(documents.medRecords.filter { $0.type == "Medical Report" }, id: \.id) { record in
                    RecordView(record: record)
                }
            }
        }.onAppear() {
            documents.fetchDocuments(appointment: appointment)
        }
    }
    struct RecordView: View {
        var record: MedicalRecord
        
        var body: some View {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string:record.image))
            }
            .padding()
        }
    }
}
