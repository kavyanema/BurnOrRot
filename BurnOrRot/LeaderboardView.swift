//
//  LeaderboardView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct LeaderboardView: View {

    @State private var entries: [RotEntry] = []

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [Color.black, Color.gray.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {

                Text("🥀 Rot Hall of Shame")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()

                if entries.isEmpty {

                    VStack(spacing: 10) {

                        Text("No rots yet")
                            .foregroundColor(.white.opacity(0.7))

                        Text("Your worst days will appear here")
                            .foregroundColor(.white.opacity(0.5))
                    }

                } else {

                    List(entries) { entry in

                        HStack {

                            VStack(alignment: .leading) {

                                Text(entry.name)
                                    .foregroundColor(.white)

                                Text(entry.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text("\(entry.steps)")
                                .foregroundColor(.red)
                        }
                        .listRowBackground(Color.black)
                    }
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
        }
        .onAppear {
            entries = LeaderboardManager.shared.load()
        }
    }
}
