//
//  BurnOrRotApp.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//
import SwiftUI

@main
struct BurnOrRotApp: App {

    init() {

        NotificationManager.shared.requestPermission()

        NotificationManager.shared.scheduleSmartNotification()

        NotificationManager.shared.scheduleLeaderboardUpdate()

        NotificationManager.shared.scheduleMidnightJudgement()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
