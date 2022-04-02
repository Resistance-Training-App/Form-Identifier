//
//  SelectRepCountingAxis.swift
//  Form Identifier
//
//  Selects the gravity axis with the highest variance which is used to count reps with.
//

import Foundation

func selectRepCountingAxis(motionManager: MotionManager) -> RepCountingAxis {
    
    let DMGrvXVariance = calcVariance(data: motionManager.bufferCopy.DMGrvX)
    let DMGrvYVariance = calcVariance(data: motionManager.bufferCopy.DMGrvY)
    let DMGrvZVariance = calcVariance(data: motionManager.bufferCopy.DMGrvZ)

    let maxVariance = max(DMGrvXVariance, DMGrvYVariance, DMGrvZVariance)
        
    switch maxVariance {

    case DMGrvXVariance:
        return RepCountingAxis.DMGravX

    case DMGrvYVariance:
        return RepCountingAxis.DMGravY

    case DMGrvZVariance:
        return RepCountingAxis.DMGravZ

    default:
        return RepCountingAxis.DMGravX
    }
}

func calcVariance(data: [Double]) -> Double {
    
    let mean = data.reduce(0, +) / Double(data.count)
    var sum: Double = 0.0
    
    for datum in data {
        sum += pow(datum - mean, 2)
    }
    
    let variance = sum / Double(data.count - 1)
    
    return variance
}
