//
//  ConfettiView.swift
//  BurnOrRot
//
//  Created by kavya Nema on 16/03/26.
//

import SwiftUI

struct ConfettiView: View {

    @State private var animate = false

    var body: some View {

        ZStack {

            ForEach(0..<20) { i in

                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -400...400) : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.2)
                        .delay(Double(i) * 0.02),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
