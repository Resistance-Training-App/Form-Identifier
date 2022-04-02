//
//  ReadMotionData.swift
//  Form Identifier
//

import Foundation

import CoreML

func read_motion_data(path: String) -> Motion {
    
    let data = read_csv(path: path)
    
    return Motion(TimeStamp: Array(data["TimeStamp"]!),
                  DMUAccelX: Array(data["DMUAccelX"]!),
                  DMUAccelY: Array(data["DMUAccelY"]!),
                  DMUAccelZ: Array(data["DMUAccelZ"]!),
                  DMGrvX: Array(data["DMGrvX"]!),
                  DMGrvY: Array(data["DMGrvY"]!),
                  DMGrvZ: Array(data["DMGrvZ"]!),
                  DMQuatX: Array(data["DMQuatX"]!),
                  DMQuatY: Array(data["DMQuatY"]!),
                  DMQuatZ: Array(data["DMQuatZ"]!),
                  DMQuatW: Array(data["DMQuatW"]!),
                  DMRotX: Array(data["DMRotX"]!),
                  DMRotY: Array(data["DMRotY"]!),
                  DMRotZ: Array(data["DMRotZ"]!),
                  DMRoll: Array(data["DMRoll"]!),
                  DMPitch: Array(data["DMPitch"]!),
                  DMYaw: Array(data["DMYaw"]!))
}

