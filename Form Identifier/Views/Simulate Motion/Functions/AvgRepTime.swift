//
//  AvgRepTime.swift
//  Form Identifier
//
//  Calculates the average rep time from an array of times at which a rep started and an array of
//  times at which reps ended.
//

import Foundation

func avgRepTime(repStartTimes: [Double], repEndTimes: [Double]) -> Double {
    
    // Rep times defined as the difference in time between the start of the rep and the end.
    let repTimes = zip(repEndTimes, repStartTimes).map(-)
    
    // Mean of all rep times.
    let average = Double(repTimes.reduce(0, +)) / Double(repStartTimes.count)
    
    return average
}
