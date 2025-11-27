//
//  eexamenApp.swift
//  eexamen
//
//  Created by user285809 on 11/27/25.
//

import SwiftUI

@main
struct SudokuApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Coordinator()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }
    }
}


