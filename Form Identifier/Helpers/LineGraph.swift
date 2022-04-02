//
//  LineGraph.swift
//  Form Identifier
//
//  Displays data in a line chart.
//
//  Modified version of: https://swdevnotes.com/swift/2021/create-a-line-chart-in-swiftui/
//

import Foundation
import SwiftUI

struct LineChartView: View {
    var title: String
    
    var yTitle: String
    var yValues: [[Double]]
    var xTitle: String
    var xValues: [Double]

    var body: some View {
        GeometryReader { gr in
            let headHeight = gr.size.height * 0.10
            VStack {
                ChartHeaderView(title: title, height: headHeight)
                ChartAreaView(yTitle: yTitle, yValues: yValues, xTitle: xTitle, xValues: xValues)
            }
        }
    }
}

struct ChartHeaderView: View {
    var title: String
    var height: CGFloat
    
    var body: some View {
        Text(title)
            .font(Font.body.weight(.bold))
            .frame(height: height)
            .padding(.leading, 30)
    }
}

struct ChartAreaView: View {
    var yTitle: String
    var yValues: [[Double]]
    var xTitle: String
    var xValues: [Double]
    
    var colours = [Color.red, Color.green, Color.blue, Color.yellow]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(yTitle)
                    .rotationEffect(Angle(degrees: 270))
                    .fixedSize()
                    .frame(width: 30, height: 200)
                ZStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color(UIColor.darkGray))
                    
                    ForEach(yValues.indices, id: \.self) { i in
                        LineShape(xValues: xValues, yValues: yValues[i])
                            .stroke(colours[i], lineWidth: 2.0)
                    }
                }
            }
            HStack {
                Spacer()
                Text(xTitle)
                    .frame(width: 100)
                    .padding(.leading, 30)
                Spacer()
            }
        }
    }
}

struct LineShape: Shape {
    var xValues: [Double]
    var yValues: [Double]
    

    func path(in rect: CGRect) -> Path {
        
        let xMin = CGFloat(xValues.min() ?? 1.0)
        let yMin = CGFloat(yValues.min() ?? 1.0)

        let x: [Double] = xMin < 0 ? xValues.map{ $0 - xMin } : xValues
        let y: [Double] = yMin < 0 ? yValues.map{ $0 - yMin } : yValues
        
        let maxWidth = rect.width / CGFloat(x.max() ?? 1.0)
        let maxHeight = rect.height / CGFloat(y.max() ?? 1.0)

        var path = Path()
        path.move(to: CGPoint(x: (rect.width - (x[0] * maxWidth)),
                              y: (rect.height - (y[0] * maxHeight))))
        for i in 1..<yValues.count {
            let pt = CGPoint(x: (rect.width - (x[i] * maxWidth)),
                             y: (rect.height - (y[i] * maxHeight)))
            path.addLine(to: pt)
        }
        return path
    }
}
