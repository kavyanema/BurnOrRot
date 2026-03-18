//
//  NameEntryView.swift
//  BurnOrRot
//
//  Created by Kavya Nema on 16/03/26.
//

import SwiftUI

struct NameEntryView: View {

    @AppStorage("username") var username: String = ""

    @State private var tempName = ""

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {

                Text("Enter Your Name")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                TextField("Your name", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button {

                    if !tempName.isEmpty {
                        username = tempName
                    }

                } label: {

                    Text("Continue")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
    }
}
