//
//  ExerciseList.swift
//  Form Identifier
//
//  Displays a list of different exercises to pick from to choose a CSV file to simulate.
//

import SwiftUI

struct ExerciseList: View {
    
    @Binding var paths: [String: [String : [String]]]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(paths.keys).sorted(), id: \.self) { exerciseName in
                    NavigationLink(destination: MotionTypeList(paths: paths, exerciseName: exerciseName)) {
                        Text(exerciseName)
                    }
                }
            }
            .navigationTitle("Simulate Motion")
        }
    }
}
