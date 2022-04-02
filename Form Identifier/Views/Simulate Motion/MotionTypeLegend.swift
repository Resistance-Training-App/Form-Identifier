//
//  MotionTypeLegend.swift
//  Form Identifier
//
//  Details which motion type is assigned to which colour.
//

import SwiftUI

struct MotionTypeLegend: View {
    
    var motionTypes: [String]
    var colours: [Color]
    
    var body: some View {
        
        HStack {
            ForEach(motionTypes.indices, id: \.self) { i in
                Spacer()
                VStack {
                    
                    // Motion type name
                    Text(motionTypes[i])
                        .foregroundColor(.black)
                    
                    // Colour
                    Rectangle()
                        .fill(colours[i])
                        .frame(width: 20, height: 20)
                }
            }
            Spacer()
        }
        .padding([.top, .bottom])
        .background(Color.gray)
        .cornerRadius(10)
    }
}
