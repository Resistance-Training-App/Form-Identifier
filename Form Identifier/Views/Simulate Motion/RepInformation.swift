//
//  RepInformation.swift
//  Form Identifier
//
//  Display overall rep metrics over the whole motion file.
//

import SwiftUI

struct RepInformation: View {
    
    var metrics: Metrics
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            HStack {
                Text("Rep Analysis")
                    .font(.title)
                    .padding(.bottom)
                Spacer()
            }
            
            DisplayMetric(label: "Reps:", intValue: metrics.repCount)
            DisplayMetric(label: "Avg. Rep Time:",
                          numValue: avgRepTime(repStartTimes: metrics.repStartTimes,
                                               repEndTimes: metrics.repEndTimes),
                          round: 2,
                          unit: "s")
            DisplayMetric(label: "Rep Time Consistency:",
                          numValue: averageDeviation(numbers: zip(metrics.repEndTimes,
                                                                  metrics.repStartTimes).map(-)),
                          round: 2,
                          unit: "%")
            DisplayMetric(label: "Avg. Range of Motion:",
                          numValue: avgRangeOfMotion(rangeOfMotion: metrics.rangeOfMotion),
                          round: 2,
                          unit: "\u{00B0}")
            DisplayMetric(label: "Range of Motion Consistency:",
                          numValue: averageDeviation(numbers: metrics.rangeOfMotion),
                          round: 2,
                          unit: "%")
        }
    }
}
