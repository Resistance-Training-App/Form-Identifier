//
//  CreateBuffers.swift
//  Form Identifier
//
//  Functions to create overlapped buffers from a CSV file.
//

import Foundation
import CoreML

func create_buffers(path: String, size: Int) -> [Motion] {

    var buffers: [Motion] = []
    
    let data = read_csv(path: path)
    
    let overlap: Int = Int(Double(size) * 0.5)
    let num_buffers = Int(floor(Double(data["TimeStamp"]!.count) / Double(overlap)))
    
    // Iterate over the number of motion buffers that need to be created.
    for i in 0..<num_buffers-1 {
        
        // Define the start and end indexes of the current motion buffer.
        let buffer_start = i * overlap
        let buffer_end = buffer_start + size

        buffers.append(Motion(TimeStamp: Array(data["TimeStamp"]![buffer_start..<buffer_end]),
                              DMUAccelX: Array(data["DMUAccelX"]![buffer_start..<buffer_end]),
                              DMUAccelY: Array(data["DMUAccelY"]![buffer_start..<buffer_end]),
                              DMUAccelZ: Array(data["DMUAccelZ"]![buffer_start..<buffer_end]),
                              DMGrvX: Array(data["DMGrvX"]![buffer_start..<buffer_end]),
                              DMGrvY: Array(data["DMGrvY"]![buffer_start..<buffer_end]),
                              DMGrvZ: Array(data["DMGrvZ"]![buffer_start..<buffer_end]),
                              DMQuatX: Array(data["DMQuatX"]![buffer_start..<buffer_end]),
                              DMQuatY: Array(data["DMQuatY"]![buffer_start..<buffer_end]),
                              DMQuatZ: Array(data["DMQuatZ"]![buffer_start..<buffer_end]),
                              DMQuatW: Array(data["DMQuatW"]![buffer_start..<buffer_end]),
                              DMRotX: Array(data["DMRotX"]![buffer_start..<buffer_end]),
                              DMRotY: Array(data["DMRotY"]![buffer_start..<buffer_end]),
                              DMRotZ: Array(data["DMRotZ"]![buffer_start..<buffer_end]),
                              DMRoll: Array(data["DMRoll"]![buffer_start..<buffer_end]),
                              DMPitch: Array(data["DMPitch"]![buffer_start..<buffer_end]),
                              DMYaw: Array(data["DMYaw"]![buffer_start..<buffer_end])))
    }

    return buffers
}
