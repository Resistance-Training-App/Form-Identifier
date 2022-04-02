//
//  RepResultRow.swift
//  Form Identifier
//
//  A single row representing information about a single rep.
//

import SwiftUI

struct RepResultRow: View {
    
    var motion: Motion
    var metrics: Metrics
    var repIndex: Int
    var repStart: Int
    var repEnd: Int
    var firstRepTime: Double
    
    @State private var showGraphs = false

    var body: some View {
        
        VStack {
            
            // Rep number and the time at which the rep started and finished.
            HStack {
                Text("Rep \(repIndex+1)")
                    .font(.title2)
                    .padding(.bottom)

                Spacer()

                Text("\(String(format: "%.2f", metrics.repStartTimes[repIndex] - firstRepTime))s - \(String(format: "%.2f", metrics.repEndTimes[repIndex] - firstRepTime))s")
                    .font(.headline)
                    .padding(.bottom)
            }

            VStack(spacing: 5) {
                
                // Time take to complete the rep.
                DisplayMetric(label: "Rep Time:",
                              numValue: metrics.repEndTimes[repIndex] - metrics.repStartTimes[repIndex],
                              round: 2,
                              unit: "s")
                
                // The angle in degrees from the start to the middle of the rep.
                DisplayMetric(label: "Range of Motion:",
                              numValue: metrics.rangeOfMotion[repIndex],
                              round: 2,
                              unit: "\u{00B0}")
                
                // Button to toggle whether the motion graphs are displayed.
                Button(action: {
                    showGraphs.toggle()
                }) {
                    HStack {
                        Text("Graphs")
                            .font(Font.body.weight(.bold))
                        Image(systemName: showGraphs ? "chevron.down" : "chevron.right")
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Line chart of motion graphs recorded by the Apple Watch during that rep.
            if (showGraphs) {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {

                        LineChartView(title: "Acceleration",
                                      yTitle: "Acceleration (X,Y,Z)",
                                      yValues: [Array(motion.DMUAccelX[repStart...repEnd]),
                                                Array(motion.DMUAccelY[repStart...repEnd]),
                                                Array(motion.DMUAccelZ[repStart...repEnd])],
                                      xTitle: "Time",
                                      xValues: (0...(repEnd)-(repStart)).map { Double($0) })
                            .frame(width: 300,
                                   height: 300,
                                   alignment: .center)

                        LineChartView(title: "Rotation",
                                      yTitle: "Rotation (X,Y,Z)",
                                      yValues: [Array(motion.DMRotX[repStart...repEnd]),
                                                Array(motion.DMRotY[repStart...repEnd]),
                                                Array(motion.DMRotZ[repStart...repEnd])],
                                      xTitle: "Time",
                                      xValues: (0...(repEnd)-(repStart)).map { Double($0) })
                            .frame(width: 300,
                                   height: 300,
                                   alignment: .center)

                        LineChartView(title: "Quaternion",
                                      yTitle: "Quaternion (X,Y,Z)",
                                      yValues: [Array(motion.DMQuatX[repStart...repEnd]),
                                                Array(motion.DMQuatY[repStart...repEnd]),
                                                Array(motion.DMQuatZ[repStart...repEnd]),
                                                Array(motion.DMQuatW[repStart...repEnd])],
                                      xTitle: "Time",
                                      xValues: (0...(repEnd)-(repStart)).map { Double($0) })
                            .frame(width: 300,
                                   height: 300,
                                   alignment: .center)

                        LineChartView(title: "Gravity",
                                      yTitle: "Gravity (X,Y,Z)",
                                      yValues: [Array(motion.DMGrvX[repStart...repEnd]),
                                                Array(motion.DMGrvY[repStart...repEnd]),
                                                Array(motion.DMGrvZ[repStart...repEnd])],
                                      xTitle: "Time",
                                      xValues: (0...(repEnd)-(repStart)).map { Double($0) })
                            .frame(width: 300,
                                   height: 300,
                                   alignment: .center)

                        LineChartView(title: "Attitude (absolute value)",
                                      yTitle: "Attitude (Roll,Pitch,Yaw)",
                                      yValues: [Array(motion.DMRoll[repStart...repEnd]).map(abs),
                                                Array(motion.DMPitch[repStart...repEnd]).map(abs),
                                                Array(motion.DMYaw[repStart...repEnd]).map(abs)],
                                      xTitle: "Time",
                                      xValues: (0...(repEnd)-(repStart)).map { Double($0) })
                            .frame(width: 300,
                                   height: 300,
                                   alignment: .center)
                    }
                }
            }
        }
    }
}
