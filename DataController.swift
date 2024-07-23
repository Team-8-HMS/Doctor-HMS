//
//  DataController.swift
//  Doctor-HMS
//
//  Created by Darshika Gupta on 18/07/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct DocumentPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onDocumentsPicked(urls)
        }
    }

    var onDocumentsPicked: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}


let db = Firestore.firestore()

var currentDoctor: Doctor = Doctor(id: "", name: "", imageURL: "", department: "")
//var app:[FirebaseAppointment] = []
//var patientData:[String:Patient] = [:]
class DocumentDataModel:ObservableObject,Identifiable{
    
    
    var appointment: FirebaseAppointment?
    @Published var medRecords:[MedicalRecord] = []
 


    func fetchDocuments(appointment:FirebaseAppointment){
        self.medRecords = []
        let db = Firestore.firestore()
        
        db.collection("medicalRecords").addSnapshotListener { [self] querySnapshot ,error in
//            if let error = error{
//                print("Error")
//            }
            guard let documents = querySnapshot?.documents else{
                print("No data found")
                return
            }
            
            for document in documents {
                print(document)
                print(appointment)
                print(appointment.patientId)
                do{
                    let data = document.data()
                  
                    if appointment.patientId == data["patientID"] as? String{
                        let id = document.documentID
                           let patientId = data["patientID"] as? String ?? ""
                           let date = data["date"] as? String ?? ""
                           let realDate = dateConverter(dateString: date) ?? Date.now
                           let filename = data["fileName"] as? String ?? ""
                           let image = data["images"] as? [String] ?? []
                           let type = data["type"] as? String ?? ""
                        let medicalRecords:MedicalRecord = MedicalRecord(id: id, patientId: patientId , date: realDate, image:image[0], fileName:filename, type:type )
                            self.medRecords.append(medicalRecords)
                        print(medRecords)
                        
                    }
                    
                }
            }
        }
    }
}

class AppViewModel: ObservableObject {
    @AppStorage("doctorId") var doctorId : String = ""
    @Published var app:[FirebaseAppointment] = []
    @Published var todayApp: [FirebaseAppointment] = []
    @Published var pendingApp: [FirebaseAppointment] = []
    @Published var patientData:[String:Patient] = [:]
    
    
    
    init() {
        if !doctorId.isEmpty {
                    fetchDoctor(doctorId: doctorId)
                }
        
        db.collection("Appointements").addSnapshotListener{ querySnapshot ,error in
            guard let documents = querySnapshot?.documents else{
                print("No data found")
                return
            }
            self.app = []
            self.todayApp = []
            self.pendingApp = []
            self.patientData = [:]
            for document in documents{
                do{
                    
                    let data = document.data()
//                    print(doctorId)
//                    print(data["doctorId"])
                    if currentDoctor.id == data["doctorId"] as? String{
                        let id = data["id"] as? String ?? ""
                        let doctorId = data["doctorId"] as? String ?? ""
                        let patientId = data["patientId"] as? String ?? ""
                        let date = data["date"] as? String ?? ""
                        let realDate = dateConverter(dateString: date) ?? Date.now
                        let timeSlot = data["timeSlot"] as? String ?? ""
                        let isPremium = data["isPremium"] as? Bool ?? false
                        let appointment:FirebaseAppointment = FirebaseAppointment(id: id, doctorId: doctorId, patientId: patientId, date: realDate, timeSlot: timeSlot, isPremium: isPremium)
                        if realDate.isSameDay(as: Date()) {
                            self.todayApp.append(appointment)
                        } else {
                            self.pendingApp.append(appointment)
                        }
//                        print("patientid --> \(patientId)")
                        db.document("Patient/\(patientId)").getDocument{documentSnapshot , error in
                            if let error = error{
                                print("error")
                            }
                            else if let documentSnapshot , documentSnapshot.exists{
                                if let data = documentSnapshot.data(){
                                    let name = data["firstname"] as? String ?? ""
                                    let image = data["imageURL"] as? String ?? ""
                                    let dob = data["dob"] as? String ?? ""
                                    let dateDOB = dateConverter(dateString: dob)
                                    self.patientData[patientId] = Patient(id: patientId, name: name, dob: dateDOB ?? Date.now, profileImage: image, status: "Pending")
//                                    print(self.patientData)
//                                    print("HIHiHiHi")
                                    
                                }
                            }
                        }
                        self.app.append(appointment)
//                        print(appointment)
                    }
//                    else{
//                        print("doctorId is // not matching")
//                    }
                    
                }
            }
        }
    }
}


func fetchDoctor(doctorId: String){
    db.collection("Doctors").document("\(doctorId)").getDocument{documentSnapshot , error in
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


func dateConverter(dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: dateString) {
        return date
    }
    
    // Add additional date formats if needed
    formatter.dateFormat = "MM/dd/yyyy"
    if let date = formatter.date(from: dateString) {
        return date
    }
    
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.date(from: dateString)
}





