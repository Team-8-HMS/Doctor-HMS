//
//  Dashboard.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 06/07/24.
//

import SwiftUI


// DashboardView
struct DashboardView: View {
    var todayAppointments: [Appointment] {
        appointments.filter { $0.date.isSameDay(as: Date()) }
    }
    
    var pendingAppointments: [Appointment] {
        todayAppointments.filter { $0.status == "Pending" }
    }

    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                GreetingView()
                Spacer()
                DateView()
            }
            .padding(.bottom, 20)

            HStack(spacing: 5) {
                CardView(title: "Total Patients for today", number: todayAppointments.count, imageName: "person.2.fill", backgroundColor: Color(hex: "#DDE2F2"))
                CardView(title: "Remaining Appointments", number: pendingAppointments.count, imageName: "calendar.badge.clock", backgroundColor: Color(hex: "#DDE2F2"))
            }
            .padding()
            .frame(height: 200)
            
            Text("Today's Patient List")
                .font(.title) // Adjust font size here
                .fontWeight(.bold)
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            HeaderRow()
            List {
                // Filter appointments for today's date
                ForEach(todayAppointments) { appointment in
                    PatientRow(patient: appointment.patient)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}




//header row at dashboard
struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Name")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 150)
//            Text("Gender")
//                .font(.subheadline)
//                .frame(width: 60, alignment: .leading)
//                .padding(.leading,60)
            Text("Timing")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 110)
            Text("Status")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 190)
            Spacer()
            Image(systemName: " ")
                .font(.subheadline)
                .frame(width: 50, alignment: .leading)
                .padding()
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}
// Components

struct GreetingView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text("Good morning!")
                //.font(.largeTitle)
                .font(.system(size: 40, weight: .bold))
                .fontWeight(.bold)
                .padding(.top, -50)
            Text("Here are your important tasks for today:")
                .font(.system(size: 25))
                .foregroundColor(.gray)
                
        }
        .padding(.vertical, 0)
        .padding(.horizontal, 10)
    }
}

struct DateView: View {
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 5)
//            Text(Date().formattedDay())
//                .font(.subheadline)
            Text(Date().formattedDate())
                .font(.title3)
                
            Text(Date().formattedMonthAndYear())
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.trailing, 20)
    }
}

struct CardView: View {
    var title: String
    var number: Int
    var imageName: String
    var backgroundColor: Color

    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text("\(number)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Patient row
struct PatientRow: View {
    
    var patient: Patient
    @State private var isSelected = false
    
    var body: some View {
        
        NavigationStack{
            
            NavigationLink(destination: DoctorNotesView()) {
                HStack(spacing: 10) {
                    
                    Image(patient.profileImage)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(patient.name)
                            .font(.headline)
                            .lineLimit(1) // Limit name to 1 line
                        Text(patient.disease)
                            .font(.subheadline)
                            .lineLimit(2) // Limit disease to 2 lines
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Text(patient.timing)
                        .font(.subheadline)
                        .frame(width: 200, alignment: .leading) // Fixed width for timing
                        .padding(.leading, 60)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text(patient.status)
                        .fontWeight(.bold)
                        .foregroundColor(statusColor(for: patient.status))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                        .padding(.horizontal,50) // horizontal padding for status
                        .background(statusBackgroundColor(for: patient.status))
                        .cornerRadius(8)
                        .frame(width: 200, alignment: .center) // Fixed width for status background
                    
                    Spacer()
                    
                        
                }
            }
        }
    }

    private func statusColor(for status: String) -> Color {
        switch status {
        case "Pending":
            return Color(red: 218/255, green: 59/255, blue: 19/255)
        case "Done":
            return Color(red: 101/255, green:200/255, blue: 102/255)
        case "Progress":
            return Color(red: 50/255, green: 0/255, blue: 255/255)
        default:
            return .gray // default color if status is unrecognized
        }
    }

    private func statusBackgroundColor(for status: String) -> Color {
        switch status {
        case "Pending":
            return Color(red: 250/255, green: 224/255, blue: 229/255)
        case "Done":
            return Color(red: 230/255, green: 246/255, blue: 231/255)
        case "Progress":
            return Color(red: 230/255, green: 230/255, blue: 247/255)
        default:
            return Color.gray.opacity(0.2)
        }
    }
}




//struct Dashboard_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}