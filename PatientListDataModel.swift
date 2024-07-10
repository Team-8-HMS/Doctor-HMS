//
//  PatientListDataModel.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 08/07/24.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

let db = Firestore.firestore()
var doctorId : String = ""

struct Patient: Identifiable {
    var id :String
    var name: String
    var dob : Date
    var profileImage: String
    var status : String
}

struct Doctor {
    var id:String
    var name:String
    var imageURL:String
    var department:String
}

var currentDoctor: Doctor = Doctor(id: "", name: "", imageURL: "", department: "")

struct Appointment: Identifiable {
    var id : String
    var status: String
    var date: Date
    var patient: Patient
}



// Sample data
var patientData:[String:Patient] = [:]




struct FirebaseAppointment : Identifiable{
    let id:String
    let doctorId:String
    let patientId:String
    let date:Date
    let timeSlot:String
    let isPremium:Bool
    let status:String = "Pending"
}

//var appointments: [Appointment] = [
////    Appointment(status: "Done", date: Date(), patient: patientData[0])
////    Appointment(status: "Done", date: Date(), patient: patientData[1]),
////    Appointment(status: "Progress", date: Date(), patient: patientData[2]),
////    Appointment(status: "Pending", date: Date(), patient: patientData[3]),
////    Appointment(status: "Pending", date: Date(), patient: patientData[3]),
////    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-04 15:45:00")!, patient: patientData[3]),
////    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-07 17:00:00")!, patient: patientData[4]), Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-05 15:45:00")!, patient: patientData[3]),
////    Appointment(status: "Pending", date: dateFormatter.date(from: "2024-07-05 17:00:00")!, patient: patientData[4])
//
//]

var app:[FirebaseAppointment] = []



func fetchAppointments(){
    db.collection("Appointements").addSnapshotListener{ querySnapshot ,error in
        app = []
        guard let documents = querySnapshot?.documents else{
            print("No data found")
            return
        }
        for document in documents{
            do{
                
                let data = document.data()
                print(doctorId)
                print(data["doctorId"])
                if doctorId == data["doctorId"] as? String{
                    let id = data["id"] as? String ?? ""
                    let doctorId = data["doctorId"] as? String ?? ""
                    let patientId = data["patientId"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let realDate = dateConverter(dateString: date)
                    let timeSlot = data["timeSlot"] as? String ?? ""
                    let isPremium = data["isPremium"] as? Bool ?? false
                    let appointment:FirebaseAppointment = FirebaseAppointment(id: id, doctorId: doctorId, patientId: patientId, date: realDate ?? Date.now, timeSlot: timeSlot, isPremium: isPremium)
                    app.append(appointment)
                    print(appointment)
                }else{
                    print("doctorId is not matching")
                }
                
            }
        }
        
    }
}

func fetchAllPatientData(){
    for item in app {
        fetchPatient(patientId: item.patientId)
    }
}



func fetchDoctor(doctorId: String){
    db.document("Doctors/\(doctorId)").getDocument{documentSnapshot , error in
        if let error = error{
            print("error")
        }
        else if let documentSnapshot , documentSnapshot.exists{
            if let data = documentSnapshot.data(){
                let name = data["name"] as? String ?? ""
                let department = data["department"] as? String ?? ""
                let image = data["imageURL"] as? String ?? ""
                currentDoctor.id = doctorId
                currentDoctor.imageURL = image
                currentDoctor.name = name
                currentDoctor.department = department
                print(currentDoctor)
                
            }
        }
    }
}


func fetchPatient(patientId: String){
    db.document("Patient/\(patientId)").getDocument{documentSnapshot , error in
        if let error = error{
            print("error")
        }
        else if let documentSnapshot , documentSnapshot.exists{
            if let data = documentSnapshot.data(){
                let name = data["name"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let dob = data["dob"] as? String ?? ""
                let dateDOB = dateConverter(dateString: dob)
                patientData[patientId] = Patient(id: patientId, name: name, dob: dateDOB ?? Date.now, profileImage: image, status: "Pending")
                print(patientData)
                
            }
        }
    }
}

func dateConverter(dateString : String) -> Date?{
    
    let dateFormatter = DateFormatter()

    // Set the date format according to the input string
    dateFormatter.dateFormat = "dd MMMM yyyy"

    // Set the locale if needed, e.g., for English
    dateFormatter.locale = Locale(identifier: "en_US")

    if let date = dateFormatter.date(from: dateString) {
        print("Converted date: \(date)")
        return date
    } else {
        print("Failed to convert date.")
        return nil
    }
}




