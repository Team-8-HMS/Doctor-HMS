//
//  ContentView.swift
//  PatientDetailsApp
//
//  Created by Dhairya bhardwaj on 11/07/24.
import SwiftUI


struct PatientDetail: View {
    var appointements:FirebaseAppointment

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
            PatientParchi(appointment: appointements)
            }
            .padding()
        }
    }
}


