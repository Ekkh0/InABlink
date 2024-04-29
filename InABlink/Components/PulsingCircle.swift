//
//  PulsingCircle.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 29/04/24.
//

import SwiftUI

struct PulsingCircleAnimation: View {
    @State private var pulsate: Bool = false
    @State var color: Color = Color.cyan
    @State var min: Double = 0.5
    @State var max: Double = 1.5
    @State var index: Double = 1.0
    @State var size: CGFloat = 100
    @State var duration: CGFloat = 1
    
    var body: some View {
            Circle()
                .fill(color)
                .zIndex(index)
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.4), radius: 0, x: 0, y: 3)
                .scaleEffect(pulsate ? max : min)
                .animation(Animation.easeInOut(duration: duration).repeatCount(1))
                .onAppear {
                    self.pulsate.toggle()
                }
    }
}

struct PulsingCircle: View {
    var duration: CGFloat = 2
    
    var body: some View {
        ZStack{
            PulsingCircleAnimation(color: Color.cyan, min: 0, max: 10, index: 4, duration: 1.78)
                .padding()
            PulsingCircleAnimation(color: Color.lilac, min: 0, max: 10, index: 3, duration: 1.5)
            PulsingCircleAnimation(color: Color.lilacLight, min: 0, max: 10, index: 2, duration: 1.28)
                .padding()
            PulsingCircleAnimation(color: Color.blue, min: 0, max: 10, index: 1, duration: duration)
                .padding()
        }
    }
}

#Preview {
    PulsingCircle()
}
