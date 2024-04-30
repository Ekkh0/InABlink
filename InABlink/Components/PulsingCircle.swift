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
    var duration: CGFloat = 1.5
    @State private var isStackVisible = true
    
    var body: some View {
        ZStack{
            if isStackVisible{
                ZStack{
                    PulsingCircleAnimation(color: Color.inner, min: 0, max: 10, index: 4, duration: duration)
                        .padding()
                    PulsingCircleAnimation(color: Color.innerMid, min: 0, max: 10, index: 3, duration: duration-0.3)
                    PulsingCircleAnimation(color: Color.outerMid, min: 0, max: 10, index: 2, duration: duration-0.6)
                        .padding()
                    PulsingCircleAnimation(color: Color.outer, min: 0, max: 10, index: 1, duration: duration-0.8)
                        .padding()
                }
            }
            
            if !isStackVisible{
                ZStack{
                    PulsingCircleAnimation(color: Color.outer, min: 10, max: 0, index: 1, duration: duration)
                        .padding()
                    PulsingCircleAnimation(color: Color.outerMid, min: 10, max: 0, index: 2, duration: duration-0.3)
                    PulsingCircleAnimation(color: Color.innerMid, min: 10, max: 0, index: 3, duration: duration-0.6)
                        .padding()
                    PulsingCircleAnimation(color: Color.inner, min: 10, max: 0, index: 4, duration: duration-0.8)
                        .padding()
                }
            }
            
        }
        .onAppear(){
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    self.isStackVisible = false
            }
        }
    }
}

#Preview {
    PulsingCircle()
}
