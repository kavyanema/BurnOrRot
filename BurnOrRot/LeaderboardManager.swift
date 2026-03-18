//
//  LeaderboardManager.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import Foundation

struct RotEntry: Codable, Identifiable {
    let id = UUID()
    let name: String
    let steps: Int
    let date: Date
}

class LeaderboardManager {

    static let shared = LeaderboardManager()

    private let key = "rotLeaderboard"

    func addRot(name: String, steps: Int) {

        var entries = load()

        let newEntry = RotEntry(
            name: name,
            steps: steps,
            date: Date()
        )

        entries.append(newEntry)

        // sort by WORST (lowest steps first)
        entries.sort { $0.steps < $1.steps }

        // keep only top 10 worst
        entries = Array(entries.prefix(10))

        save(entries)
    }

    func load() -> [RotEntry] {

        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([RotEntry].self, from: data)
        else {
            return []
        }

        return decoded
    }

    private func save(_ entries: [RotEntry]) {

        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
