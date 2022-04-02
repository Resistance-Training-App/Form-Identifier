//
//  PredictionDistribution.swift
//  Form Identifier
//
//  Details the distribution of confidence of all labels in the motion classification.
//

import SwiftUI

struct PredictionDistribution: View {
    
    @EnvironmentObject var data: SharedData
    
    var colours: [Color]
    
    var body: some View {
        VStack {
            
            if (!data.motionTypes.isEmpty) {

                // A legend showing which colour is assigned to which motion type.
                HStack {
                    ForEach(data.motionTypes.indices, id: \.self) { i in
                        Spacer()
                        VStack {
                            Text(data.motionTypes[i])
                                .foregroundColor(.black)

                            Rectangle()
                                .fill(colours[i])
                                .frame(width: 15, height: 15)
                        }
                    }
                    Spacer()
                }
            }

            if (!data.distribution.isEmpty) {
                
                // Coloured rectangle with a width in proportion to the confidence of the class
                // label.
                HStack(spacing: 0) {
                    ForEach(data.distribution.last!.indices, id: \.self) { i in
                        Rectangle()
                            .fill(colours[i] )
                            .frame(width: data.distribution.last![i] * 300, height: 20)
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(10)
    }
}
