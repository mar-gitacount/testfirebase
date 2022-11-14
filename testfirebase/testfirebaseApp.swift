//
//  testfirebaseApp.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/10.
//

import SwiftUI
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}
@main
struct testfirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainView()
            //MemberView().environmentObject(Model())
            //ContentView().environmentObject(Model())
            
        }
    }
}
