//
//  MotionManager.swift
//  MotionManager
//
//  A simplified motion manager used when simulating motion from CSV files.
//

import Foundation
import CoreMotion
import CoreML

class MotionManager: ObservableObject {
    
    let modelManager = ModelManager()

    var buffers: [Motion] = []
    var buffer: Motion = Motion.init()
    var bufferCopy = Motion()

    var repCount = 0
    var turningPoints: [Int] = []
    var repThreshold: Double = 0.5
    var repBuffer: [Double] = []
    var timeBuffer: [Double] = []
    var rangeBuffer: [Double] = []
    var repStartTimes: [Double] = []
    var repEndTimes: [Double] = []
    var repRangeOfMotions: [Double] = []

    var motionTypes: [String] = []
    var results: [String] = []
    var distribution: [[Double]] = []
}
