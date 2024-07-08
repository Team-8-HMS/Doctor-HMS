//
//  Request.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 08/07/24.
//

import SwiftUI

struct Request: Identifiable {
    var id = UUID()
    var reason: String
    var fromDate: Date?
    var toDate: Date?
    var requestDate: Date?
    var message: String
    var status: String
}

struct RequestView: View {
    @State private var selectedReason: String = "Leave"
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var requestDate = Date()
    @State private var message: String = ""
    @State private var requests = [
        Request(reason: "Reschedule", fromDate: Date(), toDate: Date(), requestDate: nil, message: "", status: "Approved"),
        Request(reason: "Leave", fromDate: nil, toDate: nil, requestDate: Date(), message: "", status: "Pending")
    ]

    var body: some View {
        HStack(spacing: 10) {  // Increased spacing here
            VStack(alignment: .leading, spacing: 20) {
                Text("Request Form")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 250)

                Form {
                    Section {
                        Picker("Reason", selection: $selectedReason) {
                            Text("Leave").tag("Leave")
                            Text("Reschedule").tag("Reschedule")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        if selectedReason == "Reschedule" {
                            DatePicker("Date", selection: $requestDate, displayedComponents: .date)
                        }

                        if selectedReason == "Leave" {
                            DatePicker("From", selection: $fromDate, displayedComponents: .date)
                            DatePicker("To", selection: $toDate, displayedComponents: .date)
                        }

                        TextField("Message", text: $message)
                            .frame(height: 150, alignment: .top)
                    }

                    Button(action: addRequest) {
                        Text("Submit")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(width: 500)  // Increased the width of the form
                //.background(Color.white) // Form background color
                .cornerRadius(10)
            }
            .padding(40)  // Increased padding here
            .background(Color.white)
            .cornerRadius(10)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(requests) { request in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Request")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("Reason: \(request.reason)")
                            if let requestDate = request.requestDate {
                                Text("Request Date: \(requestDate.formattedDate())")
                            }
                            if let fromDate = request.fromDate, let toDate = request.toDate {
                                Text("From: \(fromDate.formattedDate()) To: \(toDate.formattedDate())")
                            }
                            Text("Status: \(request.status)")
                        }
                        .padding()
                        .background(Color(hex: "#DDE2F2")) // Same background color for request cards
                        .cornerRadius(10)
                        .frame(width: 250, height: 200)
                    }
                }
                .padding()  // Increased padding here
            }
            .background(Color.white) // Scroll view background color
            .cornerRadius(10)
        }
        .padding(80)
        .background(Color(hex: "#FAFAFA")) // Increased padding here
    }

    private func addRequest() {
        let newRequest: Request

        if selectedReason == "Reschedule" {
            newRequest = Request(reason: selectedReason, fromDate: fromDate, toDate: toDate, requestDate: nil, message: message, status: "Pending")
        } else {
            newRequest = Request(reason: selectedReason, fromDate: nil, toDate: nil, requestDate: requestDate, message: message, status: "Pending")
        }

        requests.append(newRequest)
        selectedReason = "Leave"
        fromDate = Date()
        toDate = Date()
        requestDate = Date()
        message = ""
    }
}

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        RequestView()
    }
}
