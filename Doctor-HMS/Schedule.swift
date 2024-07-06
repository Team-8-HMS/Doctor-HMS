//
//  Schedule.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 06/07/24.
//

import SwiftUI

// ScheduleView
struct ScheduleView: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            CalendarView(selectedDate: $selectedDate)
                .padding(.bottom, 20)
            
            List {
                ForEach(appointments.filter { $0.date.isSameDay(as: selectedDate) }) { appointment in
                    AppointmentRow(appointment: appointment)
                }
            }
            .padding(.horizontal) // Add horizontal padding to the List
            .padding(.bottom, 10) // Add bottom padding to the List
        }
        .padding(.horizontal, -10)
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
    
    var body: some View {
        VStack {
            Text(selectedDate.formattedMonthAndYear())
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.top, -40)
            
            HStack {
                Button(action: {
                    weekOffset -= 1
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
                                .foregroundColor(selectedDate.isSameDay(as: day) ? Color(UIColor(red: 228 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)) : Color.gray)
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



//AppointmentRow 
struct AppointmentRow: View {
    var appointment: Appointment

    var body: some View {
        HStack {
            Image(appointment.patient.profileImage)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(appointment.patient.name)
                    .font(.headline)
                Text(appointment.patient.disease)
                    .font(.subheadline)
               
            }
            Spacer()
            Text(appointment.patient.timing)
                .font(.subheadline)
            Spacer()
            Text(appointment.status)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .shadow(radius: 8)
               
    }
}

//
//struct Schedule_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}

