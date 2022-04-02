//
//  PeakFinder.swift
//  Form Identifier
//
//  Locates and counts repetitions during a window of motion.
//

import Foundation

func repFinder(motionManager: MotionManager) {
    
    // Moving average size
    let avg_window = 10

    // The number of values either side of the current value to check if the current value is a
    // turning point.
    let scope = 2

    // Create moving average buffer to smooth data.
    let avgRepBuffer: [Double] = movingAverage(data: motionManager.repBuffer, scope: avg_window)

    // The index in the buffer where iteration will begin to look for turning points.
    let startingPoint = motionManager.turningPoints.count > 1 ? motionManager.turningPoints.last! + scope : scope

    // Iterate through average buffer
    for i in startingPoint...avgRepBuffer.count - 1 - scope {
        
        // Found a turning point.
        if IsTurningPoint(data: avgRepBuffer, index: i, scope: scope) {
            
            // Adjust index to account for the data shift with a moving average.
            if (i < avgRepBuffer.count - 1 - avg_window / 2) {
                motionManager.turningPoints.append(i + avg_window / 2)
            } else {
                motionManager.turningPoints.append(avgRepBuffer.count - 1)
            }
        }

        // Rep found if there are three turning points in the buffer.
        if (motionManager.turningPoints.count == 3) {
            let points: [Double] = [avgRepBuffer[motionManager.turningPoints[0]],
                                    avgRepBuffer[motionManager.turningPoints[1]],
                                    avgRepBuffer[motionManager.turningPoints[2]]]
            
            // Height of each part of the possible rep (eccentric and concentric motions)
            let height1 = abs(points[0] - points[1])
            let height2 = abs(points[1] - points[2])

            // If there was signifiant movement, count the rep (reduces false positives).
            if (height1 > motionManager.repThreshold && height2 > motionManager.repThreshold) {
                motionManager.repCount += 1
                motionManager.repStartTimes.append(motionManager.timeBuffer[motionManager.turningPoints[0]])
                motionManager.repEndTimes.append(motionManager.timeBuffer[motionManager.turningPoints[2]])

                // Calculate the range of motion of the rep.
                let rangeOfMotion = getRangeOfMotion(motion: motionManager,
                                                     repStartTime: motionManager.repStartTimes.last ?? 0,
                                                     repEndTime: motionManager.repEndTimes.last ?? 0)
                motionManager.repRangeOfMotions.append(rangeOfMotion)

                // Remove first two turning points as the third could part of a next rep.
                motionManager.turningPoints.removeFirst(2)
            } else {
                
                // Just remove the first turning point if not considered a rep as the next two could
                // be part of a rep.
                motionManager.turningPoints.removeFirst()
            }
        }
    }

    // Remove part of the buffer that has been processed and contain no more potential reps.
    if (motionManager.turningPoints.count > 0) {
        let firstTurningPoint = motionManager.turningPoints.first!

        motionManager.repBuffer.removeFirst(motionManager.turningPoints.first!)
        motionManager.timeBuffer.removeFirst(motionManager.turningPoints.first!)
        motionManager.rangeBuffer.removeFirst(motionManager.turningPoints.first!)

        motionManager.turningPoints = motionManager.turningPoints.map { $0 - firstTurningPoint }
    } else {
        motionManager.repBuffer.removeAll()
        motionManager.timeBuffer.removeAll()
        motionManager.rangeBuffer.removeAll()
    }
}
