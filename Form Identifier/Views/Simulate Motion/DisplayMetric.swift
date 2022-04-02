//
//  DisplayMetric.swift
//  Form Identifier
//
//  Displays a generic metric with a label.
//

import SwiftUI

struct DisplayMetric: View {
    
    var label: String
    var stringValue: String?
    var numValue: Double?
    var intValue: Int?
    var round: Int?
    var unit: String?
    
    var body: some View {
        HStack {
            
            // Metric label
            Text(label)
                .font(Font.body.weight(.bold))

            Spacer()

            // Display the metric value and units if included.
            if ((stringValue) != nil) {
                Text(stringValue!)
            } else if ((intValue ?? 0) > 0 || (numValue ?? 0) > 0) {
                if ((round) != nil) {
                    Text("\(String(format: "%.\(round!)f", numValue ?? intValue ?? 0))\(unit ?? "")")
                } else {
                    if (numValue != nil) {
                        Text("\(numValue ?? 0)\(unit ?? "")")
                    } else {
                        Text("\(intValue ?? 0)\(unit ?? "")")
                    }
                }

            // Displays a loading wheel if the value hasn't been calculated yet.
            } else {
                ProgressView()
            }
        }
    }
}
