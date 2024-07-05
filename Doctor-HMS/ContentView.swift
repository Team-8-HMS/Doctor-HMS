import SwiftUI

//Color Extension for Hex Conversion

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// ContentView


struct ContentView: View {
    @State private var selectedItem: String? = "Dashboard"
    let items = ["Dashboard", "Schedule", "Video call", "Requests"]
    let icons = ["house", "calendar", "video", "envelope"]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(Array(zip(items, icons)), id: \.0) { item, icon in
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(selectedItem == item ? .white : .primary)
                        Text(item)
                            .foregroundColor(selectedItem == item ? .white : .primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        selectedItem == item ? Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)) : Color.clear
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 0)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        selectedItem = item
                    }
                }
            }
            .navigationTitle("App Name")
            .listStyle(PlainListStyle())
            .background(Color.white)
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 30, trailing: 10))
        } detail: {
            if let selectedItem = selectedItem {
                DetailView(item: selectedItem)
                    .background(Color.gray.opacity(0.1))
            } else {
                Text("Select an item")
            }
        }
    }
}

// DetailView

struct DetailView: View {
    var item: String
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
                   ProfileView()
                       .padding(.top, -50)
                       .padding(.trailing, 30)
                       .padding(.bottom, 40)
                       .frame(maxWidth: .infinity, alignment: .topTrailing)
            if item == "Dashboard" {
                DashboardView()
            } else if item == "Schedule" {
                ScheduleView()
            } else {
                Text("Detail for \(item)")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 0)
    }
}

// Doctor Profile

struct ProfileView: View {
    var body: some View {
        VStack {
            
            HStack {
                ZStack {
                    Image("DrProfile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(10)
                }
                .frame(width: 80, height: 80)
                .padding(.trailing, 10)

                VStack(alignment: .leading) {
                    Text("Dr. Rishita ")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("Department")
                        .font(.title3)
                }
            }
            .padding()
        }
    }
}

// DashboardView

struct DashboardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                GreetingView()
                Spacer()
                DateView()
            }
            .padding(.bottom, 20)

            HStack(spacing: 5) {
                CardView(title: "Total Patients for today", number: 25, imageName: "person.2.fill", backgroundColor: Color(hex: "#DDE2F2"))
                CardView(title: "Total Appointments", number: 40, imageName: "calendar.badge.clock", backgroundColor: Color(hex: "#DDE2F2"))
            }
            .padding()
            .frame(height: 200)
            
            Text("Today's Patient List")
                .font(.title) // Adjust font size here
                .fontWeight(.bold)
                .padding(.top, 30)
                .frame(maxWidth: .infinity, alignment: .leading) // Set alignment to leading
            HeaderRow()
            List {
                ForEach(patientData) { patient in
                    PatientRow(patient: patient)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal)
            
        }
        .padding(.horizontal)
    }
}

// ScheduleView

struct ScheduleView: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            CalendarView(selectedDate: $selectedDate)
                .padding(.bottom, 20)
                .padding(.bottom, 10)
            List {
                ForEach(appointments.filter { $0.date.isSameDay(as: selectedDate) }) { appointment in
                    AppointmentRow(appointment: appointment)

                }
            }
        }
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
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 0)
            
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
                                .foregroundColor(selectedDate.isSameDay(as: day) ? Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)) : Color.gray)
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
                Text(appointment.patient.timing)
                    .font(.subheadline)
                Text(appointment.status)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .shadow(radius: 2)
               
    }
}

struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Name")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 100)
//            Text("Gender")
//                .font(.subheadline)
//                .frame(width: 60, alignment: .leading)
//                .padding(.leading,60)
            Text("Timing")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 180)
            Text("Status")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 130)
            Spacer()
            Image(systemName: " ")
                .font(.subheadline)
                .frame(width: 50, alignment: .leading)
                .padding()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
    }
}
// Components

struct GreetingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Good morning, Dr. Nishar")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Here are your important tasks for today:")
                .font(.title2)
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

struct PatientRow: View {
    var patient: Patient

    var body: some View {
        HStack {
            Image(patient.profileImage)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(patient.name)
                    .font(.headline)
                Text(patient.disease)
                    .font(.subheadline)
            }
            Spacer()
            Text(patient.timing)
            Spacer()
            Text(patient.status)
            Spacer()
            Menu {
                Button(action: {
                   
                }) {
                    Label("Upload Record", systemImage: "doc")
                }
                Button(action: {
                   
                }) {
                    Label("Did Not Visit", systemImage: "xmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .padding()
                    .frame(width: 100, height: 70)
            }
        }
        .padding(.vertical, 10)
    }
}

// Data Models

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
    Patient(name: "John Doe", disease: "Fever", timing: "9:00-10:00 am", status: "In progress", profileImage: "Image"),
    Patient(name: "Jane Smith", disease: "Back Pain", timing: "10:00-11:00 am", status: "In progress", profileImage: "Image 1"),
    Patient(name: "Alice Brown", disease: "Headache", timing: "11:00-12:00 pm", status: "In progress", profileImage: "Image 2"),
    Patient(name: "Robert Green", disease: "Fracture", timing: "2:00-3:00 pm", status: "In progress", profileImage: "Image"),
    Patient(name: "Emily White", disease: "Allergy", timing: "3:00-4:00 pm", status: "In progress", profileImage: "Image"),
]

let appointments = [
    Appointment(status: "Pending", date: Date().addingTimeInterval(60 * 60 * 24 * 2), patient: patientData[0]),
    Appointment(status: "Pending", date: Date().addingTimeInterval(60 * 60 * 24 * 4), patient: patientData[1]),
    Appointment(status: "Pending", date: Date().addingTimeInterval(60 * 60 * 24 * 6), patient: patientData[2]),
    Appointment(status: "Pending", date: Date().addingTimeInterval(60 * 60 * 24 * 6), patient: patientData[3]),
    Appointment(status: "Pending", date: Date().addingTimeInterval(60 * 60 * 24 * 6), patient: patientData[4]),
]

//Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Date Extension for Formatting

extension Date {
    func formattedMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }

    func formattedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: self)
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }

    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }

    var startOfWeek: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)
    }
}
