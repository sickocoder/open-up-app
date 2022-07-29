//
//  OpenUpApp.swift
//  OpenUp
//
//  Created by José Tony on 05/07/22.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey :  Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct OpenUpApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      OpenUpView()
        .environmentObject(SignInViewModel())
    }
  }
}
