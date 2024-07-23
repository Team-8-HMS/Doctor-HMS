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
import UniformTypeIdentifiers

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

struct Appointment: Identifiable {
    var id : String
    var status: String
    var date: Date
    var patient: Patient
    
    
    
}


struct FirebaseAppointment : Identifiable{
    let id:String
    let doctorId:String
    let patientId:String
    let date:Date
    let timeSlot:String
    let isPremium:Bool
    let status:String = "Pending"
}

struct MedicalRecord: Identifiable {
    var id: String
    
    var patientId : String
    var date:Date
    var image:String
    var fileName:String
    var type:String
}



