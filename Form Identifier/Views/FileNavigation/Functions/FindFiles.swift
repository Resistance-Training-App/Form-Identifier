//
//  FindFiles.swift
//  Form Identifier
//
//  Finds all CSV files included in the app and returns the file paths to those CSV files.
//

import Foundation

func find_files(paths: inout [String: [String : [String]]]) {

    let new_paths = Bundle.main.paths(forResourcesOfType: "csv", inDirectory: nil)
    
    for path in new_paths {

        let filename = path.components(separatedBy: "/").last!.components(separatedBy: "-")
        let exerciseName = filename.first!
        let motionType = filename[1]

        // Only add CSV files that are formatted correctly so other CSV files that is not motion
        // data does not get updated.
        if (paths[exerciseName] != nil) {
            if (paths[exerciseName]![motionType] != nil) {
                paths[exerciseName]![motionType]?.append(path)
            } else {
                paths[exerciseName]![motionType] = [path]
            }
        } else {
            paths[exerciseName] = [motionType : [path]]
        }
    }
}
