//
//  LogInView.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 08/07/24.
//

import SwiftUI

struct LogInView: View {
    
        @State private var email: String = ""
        @State private var password: String = ""
        @State var isForgetPasswordTapped = false
        @State var loginButtonTapped = false
        
        var body: some View {
            NavigationStack{
                ZStack {
                    // Background image
                    Image("loginbac")
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                    ZStack {
                        Image("card")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .shadow(radius: 10).frame(width: 600, height: 600)
                        
                        // Foreground content
                        VStack {
                            Spacer()
                            
                            // Email TextField
                            TextField("Email", text: $email)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .foregroundColor(.black).frame(width: 500) // Explicitly set text color
                            
                            // Password SecureField
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .disableAutocorrection(true)
                                .foregroundColor(.black).frame(width: 500) // Explicitly set text color
                            
                            NavigationLink(destination: ForgotPasswordView(), isActive: $isForgetPasswordTapped)
                            {
                                EmptyView()
                            }
                            // Forgot Password button
                            Button(action: {
                                // Handle forgot password action
                                isForgetPasswordTapped = true
                                print("Forgot Password button tapped")
                                ForgotPasswordView()
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.blue)
                                    .padding(.top, 40)
                            }
                            
    //                         Login button
                            
                           
                                                    Button(action: {
                                                        // Handle login action
    //                                                    login()
                                                    }) {
                                                        Text("Login")
                                                            .foregroundColor(.white)
                                                            .padding()
                                                            .frame(width: 300)
                                                            .background(Color.blue)
                                                            .cornerRadius(10)
                                                            .padding(.horizontal, 20)
                                                    }
                            NavigationLink(destination: DashboardView(),isActive: $loginButtonTapped) {
                                EmptyView()
                            }
                                                    Spacer()

                                                }
                            
                                            }
                            
                                        }
                                        .navigationBarTitle("")
                        }
                        .navigationBarTitle("")
                    }
    //    func login(){
    //        print("Func")
    //        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
    //            if let error = error{
    //                print("Error")
    //            }
    //            else{
    //                print("Else")
    //                loginButtonTapped = true
    //
    //            }
    //        }
    //    }
                    
    }

    //   struct LoginView_Previews: PreviewProvider {
    //       static var previews: some View {
    //           ContentView()
    //       }
    //   }
   
#Preview {
    LogInView()
}
