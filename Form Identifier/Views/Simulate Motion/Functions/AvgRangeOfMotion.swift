//
//  AvgRangeOfMotion.swift
//  Form Identifier
//
//  Calculates the average range of motion from a specific exercise set.
//

import Foundation

func avgRangeOfMotion(rangeOfMotion: [Double]) -> Double {

    // Mean of all ranges of motion calculated.
    let average = Double(rangeOfMotion.reduce(0, +)) / Double(rangeOfMotion.count)
    
    return average
}
