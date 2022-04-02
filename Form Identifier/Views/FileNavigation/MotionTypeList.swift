//
//  MotionTypeList.swift
//  Form Identifier
//
//  Displays a list of the different variations of motions for a particular exercise to pick from to
//  choose a CSV file to simulate.
//

import SwiftUI

struct MotionTypeList: View {
    
    @State var paths: [String: [String : [String]]]
    @State var exerciseName: String
    
    var body: some View {
        List {
            ForEach(Array(paths[exerciseName]!.keys).sorted(), id: \.self) { motionType in
                NavigationLink(destination: CSVList(paths: paths, exerciseName: exerciseName, motionType: motionType)) {
                    Text(motionType)
                }
            }
        }
        .navigationTitle(exerciseName)
    }
}
