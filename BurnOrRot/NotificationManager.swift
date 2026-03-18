//
//  NotificationManager.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import Foundation
import UserNotifications
import HealthKit

class NotificationManager {

    static let shared = NotificationManager()

    private let healthStore = HKHealthStore()

    // MARK: Notification permission

    func requestPermission() {

        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification error:", error)
                }
            }
    }

    // MARK: Fetch today's steps

    func fetchTodaySteps(completion: @escaping (Int) -> Void) {

        guard HKHealthStore.isHealthDataAvailable() else {
            completion(0)
            return
        }

        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in

            if let error = error {
                print("HealthKit error:", error)
                completion(0)
                return
            }

            let steps = result?
                .sumQuantity()?
                .doubleValue(for: HKUnit.count()) ?? 0

            completion(Int(steps))
        }

        healthStore.execute(query)
    }

    // MARK: Smart notification

    func scheduleSmartNotification() {

        fetchTodaySteps { steps in

            let streak = UserDefaults.standard.integer(forKey: "streak")
            let goal = UserDefaults.standard.integer(forKey: "todayGoal")

            let progress = goal > 0 ? Double(steps) / Double(goal) : 0

            var pool: [(String,String)] = []

            // High streak motivation

            if streak >= 5 {

                pool = [

                    ("🔥 Don't break it", "That streak is elite."),
                    ("🔥 Momentum", "Keep cooking."),
                    ("🔥 You're on fire", "Finish the burn."),
                    ("🔥 Streak watch", "Don't waste it."),
                    ("🔥 Discipline check", "Stay locked in.")
                ]
            }

            // Close to goal hype

            else if progress > 0.7 {

                pool = [

                    ("🚀 Almost there", "Finish the burn."),
                    ("⚡ Final push", "You're so close."),
                    ("🔥 This is it", "Don't rot now."),
                    ("🏁 Last stretch", "Seal the deal."),
                    ("🔥 Burn incoming", "Walk a little more.")
                ]
            }

            // Low steps roasting

            else if steps < 4000 {

                pool = [

                    ("📉 Steps today?", "Yikes."),
                    ("🚶 Move.", "This is getting embarrassing."),
                    ("😐 Still zero steps?", "Be serious."),
                    ("🪦 Rot check", "You alive?"),
                    ("📊 Your step count", "Not impressive."),
                    ("🚨 Reality check", "You haven't moved."),
                    ("🪑 That chair loves you", "Maybe too much.")
                ]
            }

            // Default motivation

            else {

                pool = [

                    ("🚶 Go get steps", "Your streak depends on it."),
                    ("🔥 Burn day?", "Up to you."),
                    ("⚡ Small walk?", "Future you will thank you."),
                    ("📈 Activity check", "Time to move."),
                    ("👟 Walking time", "Get outside.")
                ]
            }

            guard let pick = pool.randomElement() else { return }

            let content = UNMutableNotificationContent()
            content.title = pick.0
            content.body = pick.1
            content.sound = .default

            var date = DateComponents()
            date.hour = 21
            date.minute = 30

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: date,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: "smartNotification",
                content: content,
                trigger: trigger
            )

            DispatchQueue.main.async {
                UNUserNotificationCenter.current().add(request)
            }
        }
    }

    // MARK: Midnight judgement

    func scheduleMidnightJudgement() {

        let burnMessages = [

            ("🔥 Burn confirmed", "Yesterday counts."),
            ("🔥 Streak survives", "Good work."),
            ("🔥 No rot detected", "Respect.")
        ]

        let rotMessages = [

            ("🥀 Rot confirmed", "Yesterday was tragic."),
            ("🥀 Couch wins", "Try again today."),
            ("🥀 Movement missing", "Do better today.")
        ]

        let result = UserDefaults.standard.string(forKey: "lastResult") ?? ""

        let message = result == "burn"
            ? burnMessages.randomElement()
            : rotMessages.randomElement()

        guard let pick = message else { return }

        let content = UNMutableNotificationContent()
        content.title = pick.0
        content.body = pick.1

        var date = DateComponents()
        date.hour = 0
        date.minute = 1

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "midnightJudgement",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    func scheduleLeaderboardUpdate() {

        let messages = [

            "Rot leaderboard shifting.",
            "Someone might be beating your rot score.",
            "Leaderboard update: things look bad.",
            "Rot standings changed.",
            "Your step count might be trending downward."
        ]

        let content = UNMutableNotificationContent()
        content.title = "🚨 Rot Leaderboard Update"
        content.body = messages.randomElement() ?? "Leaderboard updated."

        var date = DateComponents()
        date.hour = 22
        date.minute = 30

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "rotLeaderboardUpdate",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
