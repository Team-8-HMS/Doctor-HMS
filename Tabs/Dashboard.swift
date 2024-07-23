import SwiftUI

// DashboardView
struct DashboardView: View {
    @StateObject var appModel = AppViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    GreetingView()
                    Spacer()
//                    DateView()
                }
                .padding(.bottom, 20)

//                HStack(spacing: 20) {
                    CardView(
                        title: "Total Appointments Today",
                        number: appModel.todayApp.count,
                        imageName: "person.2.fill",
                        backgroundColor: Color(red: 247 / 255, green: 237 / 255, blue: 234 / 255)
                    )

                Text("Today's Appointments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .foregroundColor(Color(red: 44 / 255, green: 62 / 255, blue: 80 / 255)) // Deep navy
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HeaderRow()
                
                List {
                    Section() {
                        ForEach(appModel.todayApp) { appointment in
                            AppointmentRow(appointment: appointment)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(height: CGFloat(appModel.todayApp.count) * 300) // Adjust height based on number of appointments
            }
            .padding(.horizontal)
            .accentColor(Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 0.8)))
        }
        .navigationBarTitle("Dashboard", displayMode:.inline)
    }
}

// Header row at dashboard
struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Patient Profile")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 20)
            Spacer()
            
            Text("Patient Name")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 10)
            Spacer()
            Text("Time Slot")
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
                .padding(.trailing, 35)
            
          
        }
        .padding(.vertical, 10)
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
                .foregroundColor(Color(red: 1.0, green: 107 / 255, blue: 53 / 255)) // Vibrant orange
                .padding(.top, 0)
            Text("")
                .font(.system(size: 25))
                .foregroundColor(Color(red: 107 / 255, green: 125 / 255, blue: 141 / 255))
        }
        .padding(.vertical, 0)
        .padding(.horizontal, 10)
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
                    .padding(.trailing, 20)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(number)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 170)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


#Preview {
    DashboardView()
}
