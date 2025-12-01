//
//  DostavistaApp.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import SwiftUI
import AppTrackingTransparency
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct DostavistaApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        ATTrackingManager.requestTrackingAuthorization { status in
                            switch status {
                            case .authorized:
                                print("IDFA granted")
                            case .denied, .restricted, .notDetermined:
                                print("IDFA authorization not granted")
                            @unknown default:
                                break
                            }
                        }
                    }
                }
        }
    }
}
