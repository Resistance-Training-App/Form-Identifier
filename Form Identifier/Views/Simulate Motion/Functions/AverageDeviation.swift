//
//  AverageDeviation.swift
//  Form Identifier
//
//  Calculates the average deviation of an array of numbers, used for rep time and range of motion
//  consistency percentages.
//

import Foundation

func averageDeviation(numbers: [Double]) -> Double {

    let mean = numbers.reduce(0, +) / Double(numbers.count)

    var absoluteDeviations: [Double] = []
    
    // Find the difference between all values and the mean.
    for number in numbers {
        let absoluteDeviation = abs(number - mean)
        absoluteDeviations.append(absoluteDeviation)
    }
    
    // Calculate the average deviation from the mean.
    let averageDeviation = absoluteDeviations.reduce(0, +) / Double(absoluteDeviations.count)
    
    // Convert to a percentage.
    let percentage = ((mean - averageDeviation) / mean) * 100
    
    return percentage
}
