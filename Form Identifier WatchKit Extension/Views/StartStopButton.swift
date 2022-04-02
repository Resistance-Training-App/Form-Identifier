//
//  StartStopButton.swift
//  Form Identifier
//
//  Start or stop the motion classification model and rep counting algorithm.
//

import SwiftUI

struct StartStopButton: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    
    var body: some View {
        if (workout.mode == .running) {

            // Stop exercise analysis
            Button(action: {
                workout.cancelWorkout()
                motion.stopUpdates()
                
                motion.currentIndexInPredictionWindow = 0
                motion.turningPoints.removeAll()
                motion.repBuffer.removeAll()
                motion.timeBuffer.removeAll()
                motion.rangeBuffer.removeAll()
                motion.repStartTimes.removeAll()
                motion.repEndTimes.removeAll()
                motion.repRangeOfMotions.removeAll()
                motion.motionTypes.removeAll()
                motion.results.removeAll()
                motion.distribution.removeAll()
                motion.buffer = Motion()
                motion.bufferCopy = Motion()
            }) {
                Text("Stop")
            }
            .buttonStyle(BorderedButtonStyle(tint: .red))

        } else {

            // Start exercise analysis
            Button(action: {
                workout.startWorkout()
                motion.startUpdates()
            }) {
                Text("Start")
            }
            .buttonStyle(BorderedButtonStyle(tint: .green))
        }
    }
}
