//
//  Schedule.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 06/07/24.
//

import SwiftUI

// ScheduleView
struct ScheduleView: View {
    @StateObject var appModel = AppViewModel()
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            CalendarView(selectedDate: $selectedDate)
                .padding(.bottom, 20)
            
            List {
                ForEach(appModel.app.filter { $0.date.isSameDay(as: selectedDate) }) { appointment in
                    AppointmentRow(appointment: appointment)
                }
            }
            .padding(.horizontal) // Add horizontal padding to the List
            .padding(.bottom, 10) // Add bottom padding to the List
        }
        .padding(.horizontal, -10)
        .accentColor(Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 0.8)))
    }
}

// CalendarView
struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var weekOffset: Int = 0
    private let calendar = Calendar.current
    
    private var days: [Date] {
        let today = calendar.startOfDay(for: Date())
        let startOfWeek = calendar.date(byAdding: .day, value: weekOffset * 7, to: today.startOfWeek!)!
        return (0...6).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    private var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: selectedDate)
            
    }
        
    
    var body: some View {
        VStack {
            Text(currentMonth)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.top, 0)
            
            HStack {
                Button(action: {
                    weekOffset -= 1
                    let today = calendar.startOfDay(for: Date())
                    let startOfWeek = calendar.date(byAdding: .day, value: weekOffset * 7, to: today.startOfWeek!)!
                    selectedDate = startOfWeek // update the selected date
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding()
                }
                
                Spacer()
                
                ForEach(days, id: \.self) { day in
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(selectedDate.isSameDay(as: day) ? Color(UIColor(red: 228 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)) : Color.gray.opacity(0.6))
                                .frame(width: 120, height: 100)
                            
                            VStack {
                                Text(day.formattedDay())
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                Text(day.formattedDate())
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                            }
                        }
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedDate = day
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    weekOffset += 1
                    let today = calendar.startOfDay(for: Date())
                    let startOfWeek = calendar.date(byAdding: .day, value: weekOffset * 7, to: today.startOfWeek!)!
                    selectedDate = startOfWeek // update the selected date
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
    }
}

// AppointmentRow
struct AppointmentRow: View {
    @StateObject var appModel = AppViewModel()
    var appointment: FirebaseAppointment

    var body: some View {
        NavigationStack{
            NavigationLink(destination: PatientDetail()){
        HStack {
            AsyncImage(url: URL(string: "appModel.patientData[appointment.patientId]?.profileImage" ?? "")){ image in
                image
                    .image?.resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
            }
                
            
            VStack(alignment: .leading) {
                Text(appModel.patientData[appointment.patientId]?.name ?? "no name found")
                    .font(.headline)
                Text("\(appointment.date)")
                    .font(.subheadline)
            }
            Spacer()
            Text(appointment.timeSlot)
                .font(.subheadline)
            Spacer()
           // Image(systemName: "chevron.right")
        }
        .padding()
        
    }
            .accentColor(.red)
        
            
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

//struct Schedule_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}
