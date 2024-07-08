import SwiftUI

// Color Extension for Hex Conversion
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
            TopFrameView()
        
            if item == "Dashboard" {
                DashboardView()
            } else if item == "Schedule" {
                ScheduleView()
            } else if item == "Requests" {
                RequestView()
            }else {
                Text("Detail for \(item)")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 0)
    }
}

//proile's frame
struct TopFrameView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.white
                
                HStack {
                    Spacer()
                    ProfileView()
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: 130) // Adjust height as needed
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 2) // Adjust border thickness
                    .foregroundColor(.gray),
                alignment: .bottom
            )
        }
        .edgesIgnoringSafeArea(.top)
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
                    Text("Dr. S Nirnay ")
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







let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

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

//Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
