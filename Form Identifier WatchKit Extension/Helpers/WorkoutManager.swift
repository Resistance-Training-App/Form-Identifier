//
//  WorkoutManager.swift
//  WorkoutManager
//
//  Class to manage a workout using Apple's 'HKWorkoutSession' to be able to access information
//  such as heart rate and allowing WatchOS to know a workout is running.
//

import Foundation
import HealthKit

enum WorkoutMode {
    case running
    case stopped
    case paused
    case finished
    case cancelled
}

class WorkoutManager: NSObject, ObservableObject {

    @Published var mode: WorkoutMode = .stopped


    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // Workout metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var appleWorkout: HKWorkout?

    // Start the workout.
    func startWorkout() {
        self.mode = .running

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = HKWorkoutActivityType.traditionalStrengthTraining
        configuration.locationType = .indoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in }
    }

    // Request authorisation to access HealthKit.
    func requestAuthorization() {

        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorisation for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in

        }
    }
    
    // Function to check if the user has granted access to health data.
    func hasAuthorization() -> Bool {
        switch healthStore.authorizationStatus(for: HKQuantityType.workoutType()) {
            case .sharingAuthorized:
                return true
            case .sharingDenied:
                return false
            default:
                return false
        }
    }

    // Pause the workout.
    func pause() {
        session?.pause()
        mode = .paused
    }

    // Resume the workout.
    func resume() {
        session?.resume()
        mode = .running
    }

    // End the workout.
    func endWorkout() {
        session?.end()
        mode = .finished
    }

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            default:
                return
            }
        }
    }

    // Reset the workout, used when a workout has finished and the workout's attributes need to be
    // reset.
    func resetWorkout() {
        builder = nil
        appleWorkout = nil
        session = nil
        mode = .stopped
    }
    
    // Restart the workout.
    func restartWorkout() {
        builder = nil
        appleWorkout = nil
        session = nil
        startWorkout()
    }
    
    // Cancel the workout, used when the user ends the workout within 10 seconds of starting it.
    func cancelWorkout() {
        appleWorkout = nil
        mode = .cancelled
        session?.end()
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                // Only save the workout is it was finished and lasted longer than 10 seconds.
                if (self.mode == .finished && Date().timeIntervalSince(workoutSession.startDate ?? Date.now) > 10) {
                    self.builder?.finishWorkout { (finishedWorkout, error) in
                        DispatchQueue.main.async {
                            self.appleWorkout = finishedWorkout
                        }
                    }
                } else if (self.mode == .cancelled) {
                    self.builder?.discardWorkout()
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed")
        print(error)
    }
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
