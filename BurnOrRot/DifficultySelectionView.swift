//
//  DifficultySelectionView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct DifficultySelectionView: View {

    @ObservedObject var goalManager: GoalManager

    @State private var selectedDifficulty: Difficulty?
    @State private var showConfirm = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [Color.black, Color.orange.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {

                // Header
                VStack(spacing: 8) {

                    Text("Choose Your Level")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Your daily step goal will be hidden")
                        .foregroundColor(.white.opacity(0.7))

                    Text("Difficulty cannot be changed later")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.8))
                }

                // Cards
                VStack(spacing: 18) {

                    difficultyCard(
                        difficulty: .beginner,
                        title: "Beginner",
                        range: "4,000 – 7,000 steps",
                        description: "Casual daily movement",
                        icon: "figure.walk",
                        color: .green
                    )

                    difficultyCard(
                        difficulty: .intermediate,
                        title: "Intermediate",
                        range: "7,500 – 12,000 steps",
                        description: "Balanced daily challenge",
                        icon: "flame.fill",
                        color: .orange
                    )

                    difficultyCard(
                        difficulty: .advanced,
                        title: "Advanced",
                        range: "12,000 – 20,000 steps",
                        description: "Serious burn required",
                        icon: "bolt.fill",
                        color: .red
                    )
                }

                Spacer()
            }
            .padding()
        }
        .alert("Confirm Difficulty", isPresented: $showConfirm) {

            Button("Cancel", role: .cancel) {}

            Button("Confirm") {

                if let difficulty = selectedDifficulty {
                    goalManager.chooseDifficulty(difficulty)
                }
            }

        } message: {

            if let difficulty = selectedDifficulty {

                Text("You selected \(difficulty.rawValue). This cannot be changed later.")
            }
        }
    }

    // MARK: Card

    func difficultyCard(
        difficulty: Difficulty,
        title: String,
        range: String,
        description: String,
        icon: String,
        color: Color
    ) -> some View {

        Button {

            selectedDifficulty = difficulty
            showConfirm = true

        } label: {

            HStack(spacing: 16) {

                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {

                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text(range)
                        .foregroundColor(.white.opacity(0.75))

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08))
            )
        }
    }
}
