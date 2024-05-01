//
//  PulsingCircle.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 29/04/24.
//

import SwiftUI

struct timesUp: View {
    var duration: CGFloat = 1.5
    @State var shakeHourglass: Bool = false
    @State private var isStackVisible = true
    @State private var hourGlassVisible = false
    
    var body: some View {
//        var score: Int = 0
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
            //                .modifier(ShakeEffect(shakes: 2))
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
            Image("HourGlass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .rotationEffect(shakeHourglass ? Angle(degrees: -10) : Angle(degrees: 10)) // Apply rotation for shaking effect
                .animation(Animation.easeInOut(duration: 0.2).repeatCount(5))
                .opacity(hourGlassVisible ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.3))
                .onAppear{
                    shakeHourglass.toggle()
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        shakeHourglass.toggle()
                    }
                }
        }
        .onAppear(){
            Timer.scheduledTimer(withTimeInterval: 3.75, repeats: false) { _ in
                self.isStackVisible = false
                self.hourGlassVisible = false
            }
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                self.hourGlassVisible = true
            }
        }
    }
    
}

//struct ShakeEffect: GeometryEffect {
//    var shakes: Int
//    var amplitude: CGFloat = 10
//    var animatableData: Int {
//        get { return shakes }
//        set { self.shakes = newValue }
//    }
//
//    func effectValue(size: CGSize) -> ProjectionTransform {
//        ProjectionTransform(CGAffineTransform(translationX: -amplitude + CGFloat.random(in: 0..<amplitude * 2), y: -amplitude + CGFloat.random(in: 0..<amplitude * 2)))
//            .concatenating(CGAffineTransform(rotationAngle: CGFloat.random(in: -0.1...0.1)))
//    }
//}

#Preview {
    timesUp()
}
