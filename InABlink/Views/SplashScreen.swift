//
//  SplashScreen.swift
//  InABlink
//
//  Created by Jaqueline Aurelia Langi on 30/04/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct TopCornerRadius: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        return path
    }
}




struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
//            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .bottomLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .bottomLeading)
            )
    }
}

struct ContentView: View {
    var body: some View {
        SplashScreenView()
    }
}

struct SplashScreenView: View {
    @Namespace var namespace
    @State private var animationState: AnimationState = .folded

    enum AnimationState {
        case folded
        case unfolded
        case zoomed
        case eyesopened
        case eyesclosed
        case eyesopen
        case eyesclos
        case noeyes
        case home
    }

    var body: some View {
        ZStack (alignment: .bottom){
            switch animationState {
            case .folded:
                FoldedPhoneView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationState = .unfolded
                        }
                    }
            case .unfolded:
                UnfoldedPhoneView()
//                    .transition(.slide)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationState = .zoomed
                        }
                    }
            case .zoomed:
                ZoomedPhoneView()
//                    .transition(.move(edge: .bottom))
//                    .frame(height: UIScreen.main.bounds.height * 1)
//                    .transition(.slide)
//                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .scale))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationState = .eyesopened
                        }
                    }.matchedGeometryEffect(id: "id", in: namespace)
            case .eyesopened:
                EyesView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                animationState = .eyesclosed
                        }
                    }
            case .eyesclosed:
                ZoomedPhoneView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                animationState = .eyesopen
                        }
                    }
            case .eyesopen:
                EyesView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                animationState = .eyesclos
                        }
                    }
            case .eyesclos:
                ZoomedPhoneView()
//                    .transition(.blurReplace)
//                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeInOut(duration: 5)) {
                                animationState = .noeyes
                            }
                        }
                    }
            case .noeyes:
                BeforeHomeScreenView()
//                    .transition(.blurReplace)
//                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animationState = .home
                        }
                    }
            case .home:
                HomeScreenView()
//                    .transition(.pivot)
//                    .toggleStyle(.automatic)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#FFFAF1").ignoresSafeArea())
        
    }
}

struct FoldedPhoneView: View {
    var body: some View {
        Image("folded_phone")
            .resizable()
            .scaledToFit()
    }
}

struct UnfoldedPhoneView: View {
    var body: some View {
        Image("unfolded_phone")
            .resizable()
            .scaledToFill()
    }
}

struct ZoomedPhoneView: View {
    var body: some View {
        ZStack {
            Image("beforehomescreen")
                .resizable()
                .scaledToFit()
                .clipShape(TopCornerRadius(radius: 30))
            .offset(y: 180)
            Image("matatertutup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
//                .scaledToFit()
            .offset(y: 40)
        }
    }
}

struct EyesView: View {
    var body: some View {
        ZStack {
            Image("beforehomescreen")
                .resizable()
                .scaledToFit()
                .clipShape(TopCornerRadius(radius: 30))
            .offset(y: 180)
            Image("mataterbuka")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
//                .scaledToFit()
            .offset(y: 15)
        }
    }
}

struct BeforeHomeScreenView: View {
    @State var opacityEye: CGFloat = 1
    
    var body: some View {
        ZStack {
            Image("beforehomescreen")
                .resizable()
                .scaledToFit()
                .clipShape(TopCornerRadius(radius: 30))
            .offset(y: 180)
            Image("matatertutup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
            //                .scaledToFit()
                .offset(y: 40)
                .opacity(opacityEye)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        withAnimation(.easeInOut(duration: 0.33)) {
                            opacityEye = 0
                        }
                    }
                }
        }
        .zIndex(5)
    }
}


struct HomeScreenView: View {
    @State var offsetY: CGFloat = 180
    @State var finalVisible = false
    @State var revealMenu: Bool = false
    
    var body: some View {
        ZStack {
            Image("beforehomescreen")
                .resizable()
                .scaledToFit()
                .clipShape(TopCornerRadius(radius: 30))
                .edgesIgnoringSafeArea(.all)
            .offset(y: offsetY)
//            .opacity(revealMenu ? 1 : 0)
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        offsetY = 0
//                        revealMenu.toggle()
                    }
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    withAnimation(.easeInOut(duration: 0.4)) {
//                        finalVisible = true
//                    }
//                }
            }
            if finalVisible{
                Image("final")
                    .resizable()
                    .scaledToFill()
                    .clipShape(TopCornerRadius(radius: 30))
                    .edgesIgnoringSafeArea(.all)
                    .offset(y: offsetY)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation(.easeInOut(duration: 1)) {
                                offsetY = 0
                            }
                        }
                    }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
