//
//  Form_IdentifierApp.swift
//  Form Identifier WatchKit Extension
//
//  Main app view for the Apple Watch.
//

import SwiftUI

@main
struct Form_IdentifierApp: App {
    
    @StateObject private var workout = WorkoutManager()
    @StateObject private var motion = MotionManager()
    @StateObject var data = SharedData()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(workout)
                    .environmentObject(motion)
                    .environmentObject(data)
            }
        }
    }
}
