//
//  ContentView.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.
import SwiftUI


struct PatientDetail: View {
    var patient = Patient(id: "1234567890", name: "sameer", dob: Date(), profileImage: "image", status: "pending")
    @State var documents = [labTest(name: "Prescription.pdf"), labTest(name: "X-Ray.pdf"),labTest(name: "Ultra sound.pdf"), labTest(name: "Ultra sound.pdf")]
    @State var medicalRecords = [
        MedicalRecord(date: "Feb 12, 2022", symptoms: "Back Pain", specialist: "Dr. Courtney Henry", fileURL: URL(string: "https://example.com/file1")!),
        MedicalRecord(date: "Feb 13, 2022", symptoms: "Back Pain", specialist: "Dr. Robert Fox", fileURL: URL(string: "https://example.com/file2")!),
        MedicalRecord(date: "Feb 14, 2022", symptoms: "Back Pain", specialist: "Dr. Floyd Miles", fileURL: URL(string: "https://example.com/file3")!),
        MedicalRecord(date: "Feb 15, 2022", symptoms: "Back Pain", specialist: "Dr. Darrell Steward", fileURL: URL(string: "https://example.com/file4")!)
    ]
    @State var prescriptions = [Prescription(name: "Amoxicillin"), Prescription(name: "Ibuprofen"), Prescription(name: "Paracetamol")]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PatientDetailCard(patient: patient)
                DocumentCard(documents: documents)
                MedicalRecordsList(records: medicalRecords)
                PrescriptionCard(prescriptions: prescriptions)
            }
            .padding()
        }
    }
}

struct PatientDetail_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetail()
    }
}
