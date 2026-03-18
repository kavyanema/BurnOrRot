//
//  HealthKitManager.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {

    let healthStore = HKHealthStore()

    @Published var todaySteps: Int = 0
    @Published var isAuthorized = false

    func requestAuthorization() async -> Bool {

        guard HKHealthStore.isHealthDataAvailable() else { return false }

        let stepType = HKQuantityType(.stepCount)

        do {

            try await healthStore.requestAuthorization(
                toShare: [],
                read: [stepType]
            )

            await MainActor.run {
                self.isAuthorized = true
            }

            return true

        } catch {

            print(error)
            return false
        }
    }

    func fetchTodaySteps() async {

        let stepType = HKQuantityType(.stepCount)

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now
        )

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in

            let steps = result?
                .sumQuantity()?
                .doubleValue(for: .count()) ?? 0

            DispatchQueue.main.async {
                self.todaySteps = Int(steps)
            }
        }

        healthStore.execute(query)
    }
}
