//
//  PatientList.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 06/07/24.
//

import Foundation
struct Patient: Identifiable {
    var id = UUID()
    var name: String
    var disease: String
    var timing: String
    var status: String
    var profileImage: String
}

struct Appointment: Identifiable {
    var id = UUID()
    var status: String
    var date: Date
    var patient: Patient
}



// Sample data
let patientData = [
    Patient(name: "John Doe", disease: "Fever", timing: "9:00-10:00 am", status: "Done", profileImage: "Image"),
    Patient(name: "Jane Smith", disease: "Back Pain", timing: "10:00-11:00 am", status: "Done", profileImage: "Image 1"),
    Patient(name: "Alice Brown", disease: "Headache", timing: "11:00-12:00 pm", status: "Progress", profileImage: "Image 2"),
    Patient(name: "Robert Green", disease: "Fracture", timing: "2:00-3:00 pm", status: "Pending", profileImage: "Image"),
    Patient(name: "Emily White", disease: "Allergy", timing: "3:00-4:00 pm", status: "Progress", profileImage: "Image"),
]

let appointments: [Appointment] = [
    Appointment(status: "Pending", date: Date(), patient: patientData[0]),
    Appointment(status: "Pending", date: Date(), patient: patientData[1]),
    Appointment(status: "Pending", date: Date(), patient: patientData[2]),
    Appointment(status: "Pending", date: Date(), patient: patientData[3]),
    Appointment(status: "Pending", date: Date(), patient: patientData[3]),
    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-04 15:45:00")!, patient: patientData[3]),
    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-07 17:00:00")!, patient: patientData[4]), Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-05 15:45:00")!, patient: patientData[3]),
    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-05 17:00:00")!, patient: patientData[4])

]
