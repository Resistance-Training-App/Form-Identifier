//
//  ReadCSV.swift
//  Form Identifier
//
//  Reads a motion CSV file and stores the results as a dictionary.
//

import Foundation

func read_csv(path: String) -> [String: [Double]] {
    var data: [String: [Double]] = [:]
    
    let data_columns = ["TimeStamp", "DMRoll", "DMPitch", "DMYaw", "DMRotX", "DMRotY", "DMRotZ",
                        "DMGrvX", "DMGrvY", "DMGrvZ", "DMUAccelX", "DMUAccelY", "DMUAccelZ", "DMQuatX",
                        "DMQuatY", "DMQuatW", "DMQuatZ", "AccelroX", "AceelroY", "AceelroZ"]

    do {
        let url = URL(fileURLWithPath: path)
        let s = try String(contentsOf: url)
        let rows = s.split(separator: "\n")
        var column_names: [String] = []
        var column_indexes: [Int] = []

        // Iterate through each row in the CSV file.
        for (row_index, row) in rows.enumerated() {

            let row_formatted = row.replacingOccurrences(of: ", ", with: ",")
            let columns = row_formatted.split(separator: ",")

            // Only store columns that are included in the above array of columns.
            for (column_index, column) in columns.enumerated() {
                if (row_index == 0) {
                    if data_columns.contains(String(column)) {
                        data[String(column)] = []
                        column_names.append(String(column))
                        column_indexes.append(column_index)
                    }
                } else if (column_indexes.contains(column_index)) {
                    data[column_names[column_index-9]]?.append(Double(column) ?? 0)
                }
            }
        }
    } catch {
        print("CSV Read Error")
    }

    return data
}
