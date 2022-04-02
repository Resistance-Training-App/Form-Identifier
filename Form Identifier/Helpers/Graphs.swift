//
//  Graphs.swift
//  Form Identifier
//
//  Displays the first 10 seconds of motion in line charts.
//

import SwiftUI

struct Graphs: View {
    
    @State var motion: Motion
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Motion from first 10 seconds")
                .font(.title)

            ScrollView (.horizontal, showsIndicators: false) {
                HStack {

                    // Acceleration
                    LineChartView(title: "Acceleration",
                                  yTitle: "Acceleration (X, Y, Z)",
                                  yValues: [Array(motion.DMUAccelX[0...400]),
                                            Array(motion.DMUAccelY[0...400]),
                                            Array(motion.DMUAccelZ[0...400])],
                                  xTitle: "Time",
                                  xValues: (0...400).map { Double($0) })
                        .frame(width: 300,
                               height: 300,
                               alignment: .center)

                    // Rotation
                    LineChartView(title: "Rotation",
                                  yTitle: "Rotation (X, Y, Z)",
                                  yValues: [Array(motion.DMRotX[0...400]),
                                            Array(motion.DMRotY[0...400]),
                                            Array(motion.DMRotZ[0...400])],
                                  xTitle: "Time",
                                  xValues: (0...400).map { Double($0) })
                        .frame(width: 300,
                               height: 300,
                               alignment: .center)

                    // Quaternion
                    LineChartView(title: "Quaternion",
                                  yTitle: "Quaternion (X, Y, Z, W)",
                                  yValues: [Array(motion.DMQuatX[0...400]),
                                            Array(motion.DMQuatY[0...400]),
                                            Array(motion.DMQuatZ[0...400]),
                                            Array(motion.DMQuatW[0...400])],
                                  xTitle: "Time",
                                  xValues: (0...400).map { Double($0) })
                        .frame(width: 300,
                               height: 300,
                               alignment: .center)

                    // Gravity
                    LineChartView(title: "Gravity",
                                  yTitle: "Gravity (X, Y, Z)",
                                  yValues: [Array(motion.DMGrvX[0...400]),
                                            Array(motion.DMGrvY[0...400]),
                                            Array(motion.DMGrvZ[0...400])],
                                  xTitle: "Time",
                                  xValues: (0...400).map { Double($0) })
                        .frame(width: 300,
                               height: 300,
                               alignment: .center)
                    
                    // Attitude
                    LineChartView(title: "Attitude",
                                  yTitle: "Attitude (Roll,Pitch,Yaw)",
                                  yValues: [Array(motion.DMRoll[0...400]),
                                            Array(motion.DMPitch[0...400]),
                                            Array(motion.DMYaw[0...400])],
                                  xTitle: "Time",
                                  xValues: (0...400).map { Double($0) })
                        .frame(width: 300,
                               height: 300,
                               alignment: .center)
                }
            }
        }
    }
}
