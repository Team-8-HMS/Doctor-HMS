import SwiftUI
struct ContentView: View {
    @State private var selectedItem: String? = "Dashboard"
    @State private var showLogoutConfirmation = false
    @State private var isLoggedOut = false
    let items = ["Dashboard", "Schedule", "Video call", "Requests","Profile"]
    let icons = ["house", "calendar", "video", "envelope","person"]
    var body: some View {
        NavigationStack {
            VStack {
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
                                if item == "Logout" {
                                    showLogoutConfirmation = true
                                } else {
                                    selectedItem = item
                                }
                            }
                        }
                    }
                    .navigationTitle("Admin")
//                    .navigationBarBackButtonHidden(true)
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                    .padding(EdgeInsets(top: 80, leading: 0, bottom: 30, trailing: 10))
                }
                detail: {
                    if let selectedItem = selectedItem {
                        destinationView(for: selectedItem)
                            .background(Color.gray.opacity(0.1)) // background color for detail view
                    } else {
                        Text("Select an item")
                    }
                }
                .alert(isPresented: $showLogoutConfirmation) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("OK"), action: {
                            // Handle logout action
//                            logout()
                        }),
                        secondaryButton: .cancel()
                    )
                }
//                
//                NavigationLink(destination: LoginMain()
//                                .navigationBarBackButtonHidden(true)
//                                .navigationBarHidden(true),
//                               isActive: $isLoggedOut) {
//                    EmptyView()
//                }
            }
//            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    func destinationView(for menuItem: String) -> some View {
        switch menuItem {
        case "Dashboard": // Case 1 call
            DashboardView()
        case "Schedule" : // Case 2
            ScheduleView()
        case "Video call":
            videoCallView()
        
        case "Requests":
            RequestView()
        case "Profile":
            ProfileView()
      
        default:
            Text("Unknown selection")
        }
    }
    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            isLoggedOut = true
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
//    }
}


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
                    .frame(height: 1) // Adjust border thickness
                    .foregroundColor(.gray),
                alignment: .bottom
            )
        }
        .edgesIgnoringSafeArea(.top)
    }
}


// Doctor Profile
//struct ProfileView: View {
//    var body: some View {
//        VStack {
//            HStack {
//                ZStack {
//                    AsyncImage(url: URL(string: currentDoctor.imageURL)){image in
//                        image
//                            .image?.resizable()
//                            .frame(width: 80, height: 80)
//                            .clipShape(Circle())
//                            .padding(10)
//                        
//                    }
//                        
//                }
//                .frame(width: 80, height: 80)
//                .padding(.trailing, 10)
//
//                VStack(alignment: .leading) {
//                    Text(currentDoctor.name)
//                        .fontWeight(.bold)
//                        .font(.largeTitle)
//                    Text(currentDoctor.department)
//                        .font(.title3)
//                }
//            }
//            .padding()
//        }
//    }
//}









//Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
