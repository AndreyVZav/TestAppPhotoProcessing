//
//  TestAppPhotoProcessingApp.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 18.03.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct TestAppPhotoProcessingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthContainerView()
        }
    }
}
