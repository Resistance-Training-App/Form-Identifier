//
//  SimulateMotion.swift
//  Form Identifier
//
//  Simulates and displays the results from a CSV motion file.
//

import SwiftUI

struct SimulateMotion: View {
    
    @EnvironmentObject var modelManager: ModelManager
    
    @State var motionManager: MotionManager  = MotionManager.init()
    
    @State var path: String
    @State var exerciseName: String
    @State var motionType: String
    @State var totalTime: Double = 0
    
    @State var metrics: Metrics = Metrics.init()
    @State var motion: Motion = Motion.init()

    // Choice to view the file divided by motion prediction windows or by reps.
    enum BreakdownChoice: String, CaseIterable, Identifiable {
        case windows, reps
        var id: Self { self }
    }
    
    @State var selectedBreakdownChoice: BreakdownChoice = .windows
    
    var colours: [Color] = [.red, .green, .blue, .orange, .yellow]

    var body: some View {
        ScrollView {
            VStack {

                // Display information about the motion file.
                FileInformation(exerciseName: exerciseName,
                                motionType: motionType,
                                totalTime: totalTime,
                                motionWindows: motionManager.results.count)
                
                // Display overall rep metrics over the whole motion file.
                if (motionManager.repCount > 0) {
                    Divider()
                    RepInformation(metrics: metrics)
                }
                
                // Displays a breakdown of the CSV file per motion window or per rep.
                if (!motionManager.results.isEmpty) {
                    Divider()
                    
                    // Pick between breaking the down by model prediction windows or per rep.
                    Picker("Breakdown", selection: $selectedBreakdownChoice) {
                        Text("Motion Windows").tag(BreakdownChoice.windows)
                        Text("Reps").tag(BreakdownChoice.reps)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    
                    if (selectedBreakdownChoice == .windows) {
                        
                        // A legend showing which colour is assigned to which motion type.
                        MotionTypeLegend(motionTypes: motionManager.motionTypes, colours: colours)

                        // Displays the motion classification and distribution of confidence for
                        // each motion window.
                        ForEach(motionManager.results.indices, id: \.self) { i in
                            WindowResultRow(result: motionManager.results[i],
                                            distribution: motionManager.distribution[i],
                                            colours: colours,
                                            startTime: Double(i) * 1.5)
                            Divider()

                        }
                    } else if (selectedBreakdownChoice == .reps) {
                        
                        // Displays details of each rep counted in the CSV motion file.
                        if (motionManager.repCount > 0) {
                            ForEach(0...metrics.repCount-1, id: \.self) { i in
                                
                                let repStart = motion.TimeStamp.firstIndex(of:
                                               metrics.repStartTimes[i]) ?? Array<Double>.Index(0.0)
                                let repEnd = motion.TimeStamp.firstIndex(of:
                                             metrics.repEndTimes[i]) ?? Array<Double>.Index(0.0)
                                
                                RepResultRow(motion: motion,
                                             metrics: metrics,
                                             repIndex: i,
                                             repStart: repStart,
                                             repEnd: repEnd,
                                             firstRepTime: motion.TimeStamp.first ?? 0.0)
                                Divider()
                            }
                        } else {
                            Text("No reps found.")
                        }
                    }
                } else {
                    ProgressView()
                        .padding()
                }
            }
            .navigationTitle(path.components(separatedBy: "/").last!)
            .navigationBarTitleDisplayMode(.inline)
            .padding([.leading, .trailing])
        }

        // Run the simulation.
        .task {
            if (motionManager.results.isEmpty) {
                
                // Read entire CSV file and separate into buffers.
                motion = read_motion_data(path: path)
                motionManager.buffers = create_buffers(path: path, size: 160)
                
                // Simulate motion.
                simulate(modelManager: modelManager,
                         motionManager: motionManager)

                // Total time of the recording session.
                totalTime = Double(truncating: NSNumber(value: motionManager.buffers.last!.TimeStamp.last!)) -
                            Double(truncating: NSNumber(value: motionManager.buffers.first!.TimeStamp.first!))

                // Collect metrics into a single enum.
                metrics = Metrics(repCount: motionManager.repCount,
                                  repStartTimes: motionManager.repStartTimes,
                                  repEndTimes: motionManager.repEndTimes,
                                  rangeOfMotion: motionManager.repRangeOfMotions)
            }
        }
    }
}
