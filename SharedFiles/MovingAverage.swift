//
//  MovingAverage.swift
//  Form Identifier
//
//  Applies a moving average to an array.
//

import Foundation

func movingAverage(data: [Double], scope: Int) -> [Double] {
    var avgData: [Double] = []
    
    for endIndex in scope...data.count {

        let range = Range(uncheckedBounds: (lower: endIndex - scope, upper: endIndex))
        let sum = data[range].reduce(0) { (point_1, point_2) -> Double in return point_1 + point_2 }
        let avg = sum / Double(scope)

        avgData.append(avg)
    }
    
    return avgData
}
