//
//  LogInView.swift
//  Doctor-HMS
//
//  Created by Rishita kumari on 08/07/24.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    
        @State private var email: String = ""
        @State private var password: String = ""
        @State var isForgetPasswordTapped = false
        @State var loginButtonTapped = false
        
        var body: some View {
            NavigationStack{
                ZStack {
                    // Background image
                    Image("LoginUI")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    ZStack {
                        Image("card")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .shadow(radius: 10).frame(width: 600, height: 600)
                        
                        // Foreground content
                        VStack {
                            Text("Welcome!")
                               // .font(.largeTitle.bold())
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(Color(red: 255/255, green: 101/255, blue: 74/255)) // Replace with your RGB values

                                .padding(.init(top: 550, leading: 0, bottom: -100, trailing: 450))

                           
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
                                .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            
                            // Password SecureField
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .disableAutocorrection(true)
                                .foregroundColor(.black).frame(width: 500) // Explicitly set text color
                                
                                .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            
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
                                    .padding(.bottom,20)
                            }
                            
                            NavigationLink(destination: DashboardView(),isActive: $loginButtonTapped) {
                                EmptyView()
                            }
                                                    Button(action: {
                                                       login()
                                                    }) {
                                                        Text("Login")
                                                            .foregroundColor(.white)
                                                            .padding()
                                                            .frame(width: 250)
                                                            .background(Color(red: 230/255, green: 110/255, blue: 82/255))
                                                            .cornerRadius(30)
                                                            .padding(.horizontal, 20)
                                                    }
                                                    Spacer()

                                                }
                            
                                            }
                            
                                        }
                                        .navigationBarTitle("")
                        }
                        .navigationBarTitle("")
                        
                    }
        func login(){
            
            Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
                if error != nil{
                    print("Error")
                }
                else{
                    if password == "HMS@123"{
                        isForgetPasswordTapped = true
                    }
                    else{
                        loginButtonTapped = true
                    }
                }
            }
        }
    }
#Preview {
    LogInView()
}
