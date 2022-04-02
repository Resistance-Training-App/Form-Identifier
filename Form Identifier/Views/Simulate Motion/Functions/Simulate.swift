//
//  Simulate.swift
//  Form Identifier
//
//  Simulates the motion from a CSV file by splitting the file into buffers and passing them
//  individually into motion prediction and rep counting functions.
//

import Foundation

func simulate(modelManager: ModelManager,
              motionManager: MotionManager) {
    
    for buffer in motionManager.buffers {
        
        motionManager.buffer = buffer
        motionManager.bufferCopy = buffer

        processBuffer(modelManager: modelManager,
                      motionManager: motionManager)
    }
}
