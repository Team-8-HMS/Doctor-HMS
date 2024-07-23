
import SwiftUI

// ScheduleView
struct ScheduleView: View {
    @StateObject var appModel = AppViewModel()
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            CalendarView(selectedDate: $selectedDate)
                .padding(.bottom, 20)
        
            Spacer(minLength: 20)
            HeaderRow()
            
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
        .navigationBarTitle("Schedule", displayMode: .inline)
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
                            Circle()
                                .foregroundColor(selectedDate.isSameDay(as: day) ? Color(UIColor(red: 228 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)) : Color.gray.opacity(0.6))
                                .frame(width: 80, height: 80)
                            
                            VStack {
                                Text(day.formattedDay())
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                
                                Text(day.formattedDate())
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
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
            NavigationLink(destination: PatientDetail(appointements: appointment)) {
                HStack {
                    AsyncImage(url: URL(string: appModel.patientData[appointment.patientId]?.profileImage ?? "")) { image in
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                    } placeholder: {
                        Circle()
                            .frame(width: 80, height: 80)
                            .padding(.trailing, 10)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(appModel.patientData[appointment.patientId]?.name ?? "No name found")
                            .font(.headline)
                    }
                    Spacer()
                    Text(appointment.timeSlot)
                        .font(.subheadline)
                }
                .padding()
            }
            .accentColor(.red)
        }
    }

}

