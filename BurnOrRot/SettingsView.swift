//
//  SettingsView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct SettingsView: View {

    @ObservedObject var goalManager: GoalManager

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [Color.black, Color.gray.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                Text("Settings")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 10) {

                    Text("Difficulty")
                        .foregroundColor(.gray)

                    Text(goalManager.difficulty.rawValue)
                        .font(.title2.bold())
                        .foregroundColor(.orange)

                    Text("Difficulty is locked once chosen.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
    }
}
