//
//  GoalManager.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import Foundation
import Combine

enum Difficulty: String, CaseIterable {

    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var stepRange: ClosedRange<Int> {

        switch self {

        case .beginner:
            return 4000...7000

        case .intermediate:
            return 7500...12000

        case .advanced:
            return 12000...20000
        }
    }
}

class GoalManager: ObservableObject {

    @Published var difficulty: Difficulty
    @Published var todayGoal: Int
    @Published var goalDate: Date
    @Published var streak: Int
    @Published var totalBurns: Int
    @Published var totalRots: Int
    @Published var hasChosenDifficulty: Bool
    @Published var lastResult: String

    let defaults = UserDefaults.standard

    init() {

        difficulty = Difficulty(
            rawValue: defaults.string(forKey: "difficulty") ?? ""
        ) ?? .beginner

        hasChosenDifficulty = defaults.bool(forKey: "hasChosenDifficulty")

        streak = defaults.integer(forKey: "streak")
        totalBurns = defaults.integer(forKey: "totalBurns")
        totalRots = defaults.integer(forKey: "totalRots")

        todayGoal = defaults.integer(forKey: "todayGoal")
        goalDate = defaults.object(forKey: "goalDate") as? Date ?? Date()

        lastResult = defaults.string(forKey: "lastResult") ?? ""
    }

    func chooseDifficulty(_ level: Difficulty) {

        if hasChosenDifficulty { return }

        difficulty = level
        hasChosenDifficulty = true

        defaults.set(level.rawValue, forKey: "difficulty")
        defaults.set(true, forKey: "hasChosenDifficulty")

        generateNewGoal()
    }

    func generateNewGoal() {

        todayGoal = Int.random(in: difficulty.stepRange)

        goalDate = Date()

        defaults.set(todayGoal, forKey: "todayGoal")
        defaults.set(goalDate, forKey: "goalDate")
    }

    func evaluateDay(steps: Int) {

        let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
        if steps < todayGoal {

            LeaderboardManager.shared.addRot(
                name: username,
                steps: steps
            )
        }

        if steps >= todayGoal {

            streak += 1
            totalBurns += 1
            lastResult = "burn"

        } else {

            streak = 0
            totalRots += 1
            lastResult = "rot"

            LeaderboardManager.shared.addRot(name: username, steps: steps)
        }

        defaults.set(lastResult, forKey: "lastResult")
        defaults.set(streak, forKey: "streak")
        defaults.set(totalBurns, forKey: "totalBurns")
        defaults.set(totalRots, forKey: "totalRots")
    }
}
