import SwiftUI

// DashboardView
struct DashboardView: View {
    @StateObject var appModel = AppViewModel()
//    var todayAppointments: [FirebaseAppointment] {
//        app.filter { $0.date.isSameDay(as: Date()) }
//    }
//
//    var pendingAppointments: [FirebaseAppointment] {
//        todayAppointments.filter { $0.status == "Pending" }
//    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    GreetingView()
                    Spacer()
                    DateView()
                }
                .padding(.bottom, 20)

                HStack(spacing: 40) {
                    CardView(title: "Total Patients for today", number: appModel.todayApp.count, imageName: "person.2.fill", backgroundColor: Color(red: 247 / 255, green: 237 / 255, blue: 234 / 255))
                    CardView(title: "Remaining Appointments", number: appModel.pendingApp.count, imageName: "calendar.badge.clock", backgroundColor: Color(red: 247 / 255, green: 237 / 255, blue: 234 / 255))
                }
                
                .padding()
                .frame(minHeight: 200)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

                Text("Today's Patient List")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading,20)
                    .padding(.top, 30)
                    .foregroundColor(Color(red: 44/255, green: 62/255, blue: 80/255)) // Deep navy

                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HeaderRow()
                
                List {
                    ForEach(appModel.todayApp) { appointment in
                                        AppointmentRow(appointment: appointment)
                                    }
                                }
                .listStyle(PlainListStyle())
                .frame(height: CGFloat(appModel.todayApp.count) * 200) // Adjust height based on number of appointments
            }
            .onAppear{
     //           fetchAppointments()
            }
            .padding(.horizontal)
            .accentColor(Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 0.8)))

        }
        
    }
        

        
}

// Header row at dashboard
struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Name")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 150)
            Text("Timing")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 405)
//            Text("Status")
//                .font(.subheadline)
//                .frame(width: 100, alignment: .leading)
//                .padding(.leading, 210)
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

    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good Morning!"
        case 12..<18:
            return "Good Afternoon!"
        case 18..<22:
            return "Good Evening!"
        default:
            return "Good Night!"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(greetingMessage)
                .font(.system(size: 40, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1.0, green: 107/255, blue: 53/255)) // Vibrant orange

                .padding(.top, 0)
            Text("")
                .font(.system(size: 25))
                .foregroundColor(Color(red: 107/255, green: 125/255, blue: 141/255))
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
                    .frame(width: 50, height: 50)
                    .padding(10)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .padding(.trailing, 30)
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
        .frame(maxWidth: .infinity, minHeight: 170)
        .background()
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// Patient row
struct PatientRow: View {
    var patient: Patient
    @State private var isSelected = false

    var body: some View {
        NavigationStack {
            NavigationLink(destination: PatientDetail()) {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: patient.profileImage)){image in
                        image
                            .image?.resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                    }
                        
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(patient.name)
                            .font(.headline)
                            .lineLimit(1)
                        Text("\(patient.dob)")
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                    .padding(.leading, 10)

                    Spacer()

                    Text(patient.status)
                        .fontWeight(.bold)
                       // .foregroundColor(statusColor(for: patient.status))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                       // .background(statusBackgroundColor(for: patient.status))
                        .cornerRadius(8)
                        .frame(width: 200, alignment: .center)
                    
                    Spacer()
                }
            }
        }
    }

//    private func statusColor(for status: String) -> Color {
//        switch status {
//        case "Pending":
//            return Color(red: 218 / 255, green: 59 / 255, blue: 19 / 255)
//        case "Done":
//            return Color(red: 101 / 255, green: 200 / 255, blue: 102 / 255)
//        case "Progress":
//            return Color(red: 50 / 255, green: 0 / 255, blue: 255 / 255)
//        default:
//            return .gray
//        }
//    }
//
//    private func statusBackgroundColor(for status: String) -> Color {
//        switch status {
//        case "Pending":
//            return Color(red: 250 / 255, green: 224 / 255, blue: 229 / 255)
//        case "Done":
//            return Color(red: 230 / 255, green: 246 / 255, blue: 231 / 255)
//        case "Progress":
//            return Color(red: 230 / 255, green: 230 / 255, blue: 247 / 255)
//        default:
//            return Color.gray.opacity(0.2)
//        }
//    }
}

#Preview {
    DashboardView()
}
