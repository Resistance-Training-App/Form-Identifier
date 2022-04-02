//
//  FileInformation.swift
//  Form Identifier
//
//  Displays details about the file that has been used to simulate motion.
//

import SwiftUI

struct FileInformation: View {
    
    @EnvironmentObject var modelManager: ModelManager
    
    var exerciseName: String
    var motionType: String
    var totalTime: Double
    var motionWindows: Int
    
    var body: some View {
        VStack(spacing: 5) {
            
            HStack {
                Text("File Information")
                    .font(.title)
                    .padding(.bottom)
                Spacer()
            }
            
            DisplayMetric(label: "Selected Model:", stringValue: modelManager.selectedModel.rawValue)
            DisplayMetric(label: "Simulating Motion of:", stringValue: exerciseName)
            DisplayMetric(label: "Motion Type:", stringValue: motionType)
            DisplayMetric(label: "Total Time:", numValue: totalTime, round: 0, unit: "s")
            DisplayMetric(label: "Motion Windows:", intValue: motionWindows)
        }
    }
}
