//
//  ProcessBuffer.swift
//  Form Identifier
//
//  Processes a window of motion by identifying the motion type and counting any potential reps.
//

import Foundation

func processBuffer(modelManager: ModelManager,
                   motionManager: MotionManager) {
    
    // Select axis with greatest variance for rep counting.
    let selectedAxis = selectRepCountingAxis(motionManager: motionManager)

    // Append the new motion to the rep and time buffers used for rep counting.
    // Only second half as the window is overlapped with old, already processed data.
    let timeBufferCount = motionManager.bufferCopy.TimeStamp.count
    let rangeBufferCount = motionManager.bufferCopy.DMRoll.count

    if (timeBufferCount > 0) {
        motionManager.timeBuffer.append(contentsOf:
            Array(motionManager.bufferCopy.TimeStamp[timeBufferCount/2...timeBufferCount-1]))
        motionManager.rangeBuffer.append(contentsOf:
            Array(motionManager.bufferCopy.DMRoll[rangeBufferCount/2...rangeBufferCount-1]))

        switch selectedAxis {
        case .DMGravX:
            let repBufferCount = motionManager.bufferCopy.DMGrvX.count
            motionManager.repBuffer.append(contentsOf:
                Array(motionManager.bufferCopy.DMGrvX[repBufferCount/2...repBufferCount-1]))
        case .DMGravY:
            let repBufferCount = motionManager.bufferCopy.DMGrvY.count
            motionManager.repBuffer.append(contentsOf:
                Array(motionManager.bufferCopy.DMGrvY[repBufferCount/2...repBufferCount-1]))
        case .DMGravZ:
            let repBufferCount = motionManager.bufferCopy.DMGrvZ.count
            motionManager.repBuffer.append(contentsOf:
                Array(motionManager.bufferCopy.DMGrvZ[repBufferCount/2...repBufferCount-1]))
        }
    }

    // Make prediction on the current motion type.
    makePrediction(modelManager: modelManager,
                   motionManager: motionManager)

    // Reps are only looked for when the motion type prediction suggests the user is currently
    // performing the exercise. Prevents false positives in between sets and increases efficiency.
    let latestMotion = motionManager.results.last ?? "Other"
    let secondLatestMotion = motionManager.results[exist: motionManager.results.count-2] ?? "Other"

    if (latestMotion != "Other" || secondLatestMotion != "Other") {
        repFinder(motionManager: motionManager)

    // Keep the rep and time buffers updated ready for the user to start exercising.
    } else if (motionManager.repBuffer.count >= ModelManager.predictionWindowSize &&
               motionManager.timeBuffer.count >= ModelManager.predictionWindowSize &&
               motionManager.rangeBuffer.count >= ModelManager.predictionWindowSize) {
        
        motionManager.repBuffer = Array(motionManager.repBuffer.dropFirst(ModelManager.frequency))
        motionManager.timeBuffer = Array(motionManager.timeBuffer.dropFirst(ModelManager.frequency))
        motionManager.rangeBuffer = Array(motionManager.rangeBuffer.dropFirst(ModelManager.frequency))
    }
}
