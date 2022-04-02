//
//  CSVList.swift
//  Form Identifier
//
//  Displays all CSV files related to a particular exercise and motion to pick from to choose a CSV
//  file to simulate.
//

import SwiftUI

struct CSVList: View {
    
    @State var paths: [String: [String : [String]]]
    @State var exerciseName: String
    @State var motionType: String
    
    var body: some View {
        
        // Displays all CSV files related to a particular exercise and motion.
        List {
            ForEach(paths[exerciseName]![motionType]!.sorted(), id: \.self) { path in
                NavigationLink(destination: SimulateMotion(path: path,
                                                           exerciseName: exerciseName,
                                                           motionType: motionType)) {
                    Text(path.components(separatedBy: "/").last!)
                }
            }
        }
        .navigationTitle(motionType)
    }
}
