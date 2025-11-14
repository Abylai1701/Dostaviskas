//
//  DostavistaApp.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import SwiftUI
import AppTrackingTransparency

@main
struct DostavistaApp: App {
    
    @Environment(\.scenePhase) var scenePhase

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
