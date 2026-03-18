//
//  IntroView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct IntroView: View {

    @Binding var finishedIntro: Bool

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [Color.black, Color.orange.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {

                Spacer()

                // Title
                Text("Burn or Rot")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.white)

                // Description
                VStack(spacing: 14) {

                    Text("Walk enough today → Burn 🔥")
                    Text("Do nothing today → Rot 🥀")

                    Text("Your step goal is hidden.")
                        .foregroundColor(.white.opacity(0.7))

                    Text("Beat the goal to keep your streak alive.")
                        .foregroundColor(.white.opacity(0.7))
                }
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)

                // CTA Button
                Button {

                    finishedIntro = true

                } label: {

                    Text("Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [Color.orange, Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }

                Spacer()
            }
            .padding()
        }
    }
}
