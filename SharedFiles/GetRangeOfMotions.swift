//
//  GetRangeOfMotions.swift
//  Form Identifier
//
//  Calculates the angle rotated for each rep.
//

import Foundation

func getRangeOfMotions(motion: Motion,
                      repStartTimes: [Double],
                      repEndTimes: [Double]) -> [Double] {

    var rangeOfMotion: [Double] = []

    // No reps found
    if (repStartTimes.isEmpty) {
        return []
    }
    
    // Iterate through each rep.
    for i in 0...repStartTimes.count-1 {
        
        // Find the index at which the rep started and finished.
        let repStart = motion.TimeStamp.firstIndex(of: repStartTimes[i]) ?? Array<Double>.Index(0.0)
        let repEnd = motion.TimeStamp.firstIndex(of: repEndTimes[i]) ?? Array<Double>.Index(0.0)

        // Calculate the range of motion.
        rangeOfMotion.append(getRollAngle(roll: Array(motion.DMRoll[repStart...repEnd]).map(abs)))
    }

    return rangeOfMotion
}
