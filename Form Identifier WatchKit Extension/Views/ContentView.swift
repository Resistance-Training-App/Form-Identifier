//
//  ContentView.swift
//  Form Identifier WatchKit Extension
//
//  Main view for displaying the current model, current prediction and number of reps counted along
//  with button controls.
//

import SwiftUI
import HealthKit
import CoreMotion

struct ContentView: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var data: SharedData
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        TimelineView(NumbersTimelineSchedule(from: Date())) { context in
            VStack {
                
                if (data.selectedModel.count > 0) {
                    
                    // Current model selected.
                    DisplayMetric(label: "Model:", stringValue: motion.modelManager.selectedModel.rawValue)
                    
                    // Current motion prediction.
                    DisplayMetric(label: "Prediction:", stringValue: motion.results.last ?? "")
                    
                    // Number of reps counted.
                    DisplayMetric(label: "Reps:", stringValue: String(motion.repCount))

                } else {
                    Text("Fetching data from your iPhone.")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    ProgressView()
                }

                Spacer()

                // Buttons to start, stop and reset the motion classification model and rep counting
                // algorithm.
                HStack {
                    StartStopButton()
                    ResetButton()
                }
            }
        }

        // Update the data being sent and displayed on the iPhone.
        .onReceive(timer) { time in
            data.update(newValue: motion.results,
                        newValue2: motion.distribution,
                        newValue3: motion.repCount,
                        newValue4: motion.motionTypes)
        }
        .onAppear {
            workout.requestAuthorization()
        }
        
        // Update the current selected model when the setting is changed on the iPhone.
        .onChange(of: data.selectedModel) { value in

            switch value {

            case "Bicep Curl":
                motion.modelManager.selectedModel = .BicepCurl
                
            case "Lateral Raise":
                motion.modelManager.selectedModel = .LateralRaise
                
            case "Shoulder Press":
                motion.modelManager.selectedModel = .ShoulderPress
                
            case "Exercise":
                motion.modelManager.selectedModel = .Exercise
                
            default:
                print("Unknown model selected.")
            }
            
        }
    }
}
