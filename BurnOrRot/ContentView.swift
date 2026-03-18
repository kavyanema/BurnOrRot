//
//  ContentView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject var healthManager = HealthKitManager()
    @StateObject var goalManager = GoalManager()

    @AppStorage("username") var username: String = ""
    @AppStorage("seenIntro") var seenIntro: Bool = false

    @State private var glow = false
    @State private var showConfetti = false

    // MARK: Progress

    var progress: Double {

        guard goalManager.todayGoal > 0 else { return 0 }

        return min(
            Double(healthManager.todaySteps) /
            Double(goalManager.todayGoal),
            1
        )
    }

    var isBurning: Bool {
        healthManager.todaySteps >= goalManager.todayGoal
    }

    // MARK: Burn Rank

    var burnRank: String {

        if progress >= 1.0 { return "S – Elite Burner" }
        if progress >= 0.8 { return "A – Strong Day" }
        if progress >= 0.6 { return "B – Decent Effort" }
        if progress >= 0.4 { return "C – Danger Zone" }
        if progress >= 0.2 { return "D – Rot Incoming" }

        return "F – Full Rot"
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            if !seenIntro {

                IntroView(finishedIntro: $seenIntro)

            } else if username.isEmpty {

                NameEntryView()

            } else if !goalManager.hasChosenDifficulty {

                DifficultySelectionView(goalManager: goalManager)

            } else {

                mainView
            }
        }
        .task {

            let success = await healthManager.requestAuthorization()

            if success {

                goalManager.generateNewGoal()

                await healthManager.fetchTodaySteps()
            }
        }
    }

    // MARK: Main Screen

    var mainView: some View {

        ZStack {

            backgroundGradient

            if showConfetti {
                ConfettiView()
            }

            VStack(spacing: 35) {

                Spacer()

                Text(isBurning ? "🔥 BURN" : "🥀 ROT")
                    .font(.system(size: 50, weight: .black))
                    .foregroundColor(.white)

                Text("\(healthManager.todaySteps)")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: glowColor.opacity(glow ? 0.9 : 0.3),
                            radius: glow ? 30 : 10)
                    .scaleEffect(glow ? 1.05 : 1)
                    .animation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                        value: glow
                    )
                    .onAppear {

                        if progress > 0.6 {
                            glow = true
                        }
                    }
                    .onChange(of: isBurning) { burning in

                        if burning {
                            showConfetti = true
                        }
                    }

                Text("Rank: \(burnRank)")
                    .font(.headline)
                    .foregroundColor(.orange)

                ProgressView(value: progress)
                    .tint(.orange)
                    .scaleEffect(2)

                Text("🔥 Streak x\(goalManager.streak)")
                    .foregroundColor(.orange)

                HStack(spacing: 25) {

                    NavigationLink {

                        LeaderboardView()

                    } label: {

                        Text("Rot Hall of Shame")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.25))
                            .cornerRadius(12)
                    }

                    NavigationLink {

                        SettingsView(goalManager: goalManager)

                    } label: {

                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.25))
                            .cornerRadius(12)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    // MARK: Background

    var backgroundGradient: LinearGradient {

        if isBurning {

            return LinearGradient(
                colors: [Color.red, Color.orange, Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
        }

        if progress > 0.7 {

            return LinearGradient(
                colors: [Color.orange.opacity(0.8), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
        }

        return LinearGradient(
            colors: [Color.black, Color.gray.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: Glow Color

    var glowColor: Color {

        if isBurning { return .red }

        if progress > 0.9 { return .orange }

        if progress > 0.6 { return .yellow }

        return .clear
    }
}
