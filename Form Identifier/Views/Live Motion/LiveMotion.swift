//
//  LiveMotion.swift
//  Form Identifier
//
//  Displays live data from the Apple Watch app such as current motion prediction and current
//  number of reps counted.
//

import SwiftUI

struct LiveMotion: View {
    
    @EnvironmentObject var data: SharedData
    @EnvironmentObject var modelManager: ModelManager
    
    var colours: [Color] = [.green, .blue, .red, .orange, .yellow]

    var body: some View {
        NavigationView {
            VStack {
                
                DisplayMetric(label: "Selected Model:", stringValue: modelManager.selectedModel.rawValue)

                Spacer()

                if (data.results.count > 0) {
                    
                    // Prediction string on the type of motion.
                    Text(data.results.last ?? "")
                        .font(.system(size: 60))
                        .bold()
                    
                    // Number of reps counted.
                    Text(String(data.count))
                        .font(.system(size: 60))
                        .bold()
                    
                    Spacer()

                    // Distribution of the confidence of each type of motion for the current prediction.
                    PredictionDistribution(colours: colours)
                        .padding()
                } else {
                    Text("Press Start on your Apple Watch to begin.")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Live Motion")
        }
    }
}
