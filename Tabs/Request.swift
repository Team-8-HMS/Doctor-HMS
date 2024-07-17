import Firebase
import FirebaseFirestore
import SwiftUI

struct Request: Identifiable {
    var id = UUID()
    var doctorName: String
    var doctorImage: String
    var doctorId: String
    var department: String
    var reason: String
    var fromDate: Date?
    var toDate: Date?
    var requestDate: Date?
    var message: String
    var status: String
}

struct RequestView: View {
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var message: String = ""
    @State private var selectedSegment = 0
    @State private var requests: [Request] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var doctorDetailRequest = currentDoctor

    var body: some View {
        VStack {
            Picker("Options", selection: $selectedSegment) {
                Text("Request Form").tag(0)
                Text("Requests Sent").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(height: 60)
            .padding()

            if selectedSegment == 0 {
                requestFormView
            } else {
                requestsSentView
            }
        }
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Request")
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            fetchRequests()
        }
    }

    private var requestFormView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack {
                List {
                    DatePicker("From", selection: $fromDate, displayedComponents: [.date, .hourAndMinute])
                        .frame(height: 60)
                    DatePicker("To", selection: $toDate, displayedComponents: [.date, .hourAndMinute])
                        .frame(height: 60)
                    TextField("Message", text: $message)
                        .frame(height: 150, alignment: .top)
                }
                .frame(height: 300)
                Button(action: addRequest) {
                    Text("Submit")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .background(Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 1)))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 40)
            }
            .cornerRadius(10)
            .listStyle(PlainListStyle())
            Spacer()
        }
        .padding(40)
        .cornerRadius(10)
    }

    private var requestsSentView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 197), spacing: 40)]) {
                ForEach(requests) { request in
                    RequestCardView(request: request)
                }
            }
            .padding()
        }
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
        .cornerRadius(10)
    }

    private func addRequest() {
        let currentDate = Date()
        let newRequest = Request(doctorName: doctorDetailRequest.name, doctorImage: doctorDetailRequest.imageURL, doctorId: doctorDetailRequest.id, department: doctorDetailRequest.department, reason: message, fromDate: fromDate, toDate: toDate, requestDate: currentDate, message: message, status: "Pending")

        FirestoreService.shared.addRequest(request: newRequest) { error in
            if let error = error {
                alertMessage = "Failed to submit request: \(error.localizedDescription)"
            } else {
                alertMessage = "Request submitted successfully"
                requests.append(newRequest)
                fromDate = Date()
                toDate = Date()
                message = ""
            }
            showingAlert = true
        }
    }

    private func fetchRequests() {
        FirestoreService.shared.fetchRequests(forDoctorId: doctorDetailRequest.id) { (fetchedRequests, error) in
            if let error = error {
                alertMessage = "Failed to fetch requests: \(error.localizedDescription)"
                showingAlert = true
            } else if let fetchedRequests = fetchedRequests {
                requests = fetchedRequests
            }
        }
    }
}

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    func addRequest(request: Request, completion: @escaping (Error?) -> Void) {
        let requestData: [String: Any] = [
            "doctorName": request.doctorName,
            "doctorImage": request.doctorImage,
            "doctorId": request.doctorId,
            "department": request.department,
            "reason": request.reason,
            "fromDate": request.fromDate ?? NSNull(),
            "toDate": request.toDate ?? NSNull(),
            "requestDate": request.requestDate ?? NSNull(),
            "message": request.message,
            "status": request.status
        ]

        db.collection("requests").addDocument(data: requestData) { error in
            completion(error)
        }
    }

    func fetchRequests(forDoctorId doctorId: String, completion: @escaping ([Request]?, Error?) -> Void) {
        db.collection("requests").whereField("doctorId", isEqualTo: doctorId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var requests = [Request]()
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let request = Request(
                        id: UUID(uuidString: document.documentID) ?? UUID(),
                        doctorName: data["doctorName"] as? String ?? "",
                        doctorImage: data["doctorImage"] as? String ?? "",
                        doctorId: data["doctorId"] as? String ?? "",
                        department: data["department"] as? String ?? "",
                        reason: data["reason"] as? String ?? "",
                        fromDate: (data["fromDate"] as? Timestamp)?.dateValue(),
                        toDate: (data["toDate"] as? Timestamp)?.dateValue(),
                        requestDate: (data["requestDate"] as? Timestamp)?.dateValue(),
                        message: data["message"] as? String ?? "",
                        status: data["status"] as? String ?? ""
                    )
                    requests.append(request)
                }
                completion(requests, nil)
            }
        }
    }
}

struct RequestCardView: View {
    var request: Request

    var body: some View {
        VStack {
            Text("Reason: \(request.reason)")
                .font(.title2)
                .foregroundColor(.black)

            if let fromDate = request.fromDate, let toDate = request.toDate {
                Text("From: \(fromDate.formattedDate()) To: \(toDate.formattedDate())")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            if let requestDate = request.requestDate {
                Text("Request Date: \(requestDate.formattedDate())")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            Text("Status: \(request.status)")
                .font(.title3.bold())
                .foregroundColor(.black)
        }
        .frame(width: 220, height: 220)
        .background(Color(UIColor(red: 225 / 255, green: 101 / 255, blue: 74 / 255, alpha: 0.1)))
        .cornerRadius(36)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 5)
    }
}

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        RequestView()
    }
}
