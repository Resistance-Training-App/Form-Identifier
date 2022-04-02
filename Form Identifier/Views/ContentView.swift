//
//  ContentView.swift
//  Form Identifier
//
//  Main view divided into three tabs, simulated motion, live motion and settings.
//

import SwiftUI
import Charts

struct ContentView: View {

    @StateObject var modelManager = ModelManager()
    @StateObject var data = SharedData()
    
    @State private var paths: [String: [String : [String]]] = [:]
    @State private var selection: Tab = .simulate

    // Tab selection
    enum Tab {
        case simulate
        case live
        case settings
    }
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $selection) {

            // List of exercises to select from to find a CSV file to simulate motion from.
            ExerciseList(paths: $paths)
                .tabItem {
                    Label("Simulate Motion", systemImage: "chart.xyaxis.line")
                }
                .tag(Tab.simulate)
            
            // View live data from the Apple Watch app.
            LiveMotion()
                .tabItem {
                    Label("View Live Motion", systemImage: "applewatch")
                }
                .tag(Tab.live)
            
            // App settings to change the current classification model that is used.
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .environmentObject(modelManager)
        .environmentObject(data)
        .task {
            // Fetch motion CSV files stored locally on the iPhone.
            find_files(paths: &paths)
        }

        // Update the current model on the Apple Watch.
        .onReceive(timer) { time in
            data.changeModel(newValue: modelManager.selectedModel.rawValue)
        }
    }
}
