//
//  ResetButton.swift
//  Form Identifier WatchKit Extension
//
//  Reset the current motion classification prediction and set the number of reps counted to 0.
//

import SwiftUI

struct ResetButton: View {

    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager

    var body: some View {

        // Stop exercise analysis and set current number of reps to 0.
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
            motion.repCount = 0
            motion.buffer = Motion()
            motion.bufferCopy = Motion()
        }) {
            Text("Reset")
        }
        .buttonStyle(BorderedButtonStyle(tint: .orange))
    }
}
