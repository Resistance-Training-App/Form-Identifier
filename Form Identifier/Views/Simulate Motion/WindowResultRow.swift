//
//  WindowResultRow.swift
//  Form Identifier
//
//  A single row representing a single window of motion prediction information.
//

import SwiftUI

struct WindowResultRow: View {
    
    var result: String
    var distribution: [Double]
    var colours: [Color]
    var startTime: Double
    
    private let windowLength: Int = ModelManager.predictionWindowSize / ModelManager.frequency
    
    var body: some View {
        VStack {
            
            // The time that the window covers.
            HStack {
                if (startTime == 0) {
                    Text("0s - \(windowLength)s")
                        .font(.title2)
                        .padding(.bottom)
                } else {
                    Text("\(String(format: "%.1f", startTime))s - \(String(format: "%.1f", startTime + Double(windowLength)))s")
                        .font(.title2)
                        .padding(.bottom)
                }
                Spacer()
            }
            
            VStack(spacing: 5) {
                
                // Motion classification result.
                DisplayMetric(label: "Motion Classification:", stringValue: result)
                
                // Details the distribution of confidence of all labels in the classification.
                HStack {
                    Text("Confidence Distribution:")
                        .font(Font.body.weight(.bold))
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(distribution.indices, id: \.self) { i in
                            Rectangle()
                                .fill(colours[i])
                                .frame(width: distribution[i] * 100, height: 10)
                        }
                    }
                }
            }
        }
    }
}
