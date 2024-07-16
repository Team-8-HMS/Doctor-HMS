//
//  Doctor_HMSApp.swift
//  Doctor-HMS
//
//  Created by Krsna Sharma on 04/07/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil{
                ContentView()
            }
            else{
                LogInView()
            }
//            LogInView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

