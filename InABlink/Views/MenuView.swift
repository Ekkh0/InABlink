//
//  ContentView.swift
//  InABlinkUI
//
//  Created by Putri Wulandari Oktaviani on 29/04/24.
//

import SwiftUI

//HEX COLOR CODE
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct MenuView: View {
    @State var rotation: CGFloat = 0.0
    @Binding var toggleMode: Bool
    @State var mathHighScore: Int = 0
    @State var colorHighScore: Int = 0
    @Binding var startGameToggle: Bool
    @Binding var tapped: Bool
    let generator = UIImpactFeedbackGenerator(style: .light)
    @StateObject var soundManager = SoundManager()
    
    var body: some View {
        ZStack(alignment: .top) {
            Image( "Home Screen")
                .zIndex(1)
                .scaledToFit()
                .ignoresSafeArea()
            VStack  {
                ZStack {
                    VStack {
                        ZStack(alignment: .top){
                            
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .opacity(!toggleMode ? 1: 0)
                                .frame(width:300, height:118)
                            
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red,.red,.orange, .orange,.blue,.blue]), startPoint: .top, endPoint: .bottom))
                                .rotationEffect(.degrees(rotation))
                                .mask{
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .frame(width:270.5, height:120)
                                }
                                .zIndex(1)
                            VStack{
                                Image("math game")
                                    .onTapGesture {
                                        if !tapped{
                                            playButtonClickSound()
                                            tapped = true
                                            startGameToggle.toggle()
                                            toggleMode = false
                                            generator.prepare()
                                            generator.impactOccurred()
                                        }
                                    }
                                    .padding(5)
                                
                                HStack(alignment: .center) {
                                    Image(systemName: "crown.fill")
                                        .font(GroteskBold(30))
                                        .foregroundColor(Color(hex: 0xFFE03C))
                                    
                                    Text("\(mathHighScore)")
                                        .font(GroteskBold(30))
                                        .foregroundColor(Color(hex: 0xFFFAF1))
                                }
                                .offset(y: -7.5)
                            }
                            .zIndex(1)
                            
                            
                            RoundedRectangle(cornerRadius: 12, style:.continuous)
                                .zIndex(0.5)
                                .frame(width:256, height:160)
                                .foregroundColor(Color(hex: 0xEF652A))
                                .offset(y: 5)
                        }//Zstack1
                        .offset(y:0)
                        
                    }
                }//Zstack2
                ZStack {
                    VStack {
                        ZStack(alignment: .top){
                            
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .opacity(toggleMode ? 1: 0)
                                .frame(width:300, height:118)
                            
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red,.red,.orange, .orange,.blue,.blue]), startPoint: .top, endPoint: .bottom))
                                .rotationEffect(.degrees(rotation))
                                .mask{
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .frame(width:270.5, height:120)
                                }
                                .zIndex(1)
                            VStack{
                                Image("color puzzle")
                                    .onTapGesture {
                                        if !tapped{
                                            playButtonClickSound()
                                            tapped = true
                                            startGameToggle.toggle()
                                            toggleMode = true
                                            generator.prepare()
                                            generator.impactOccurred()
                                        }
                                    }
                                    .padding(5)
                                
                                HStack(alignment: .center) {
                                    Image(systemName: "crown.fill")
                                        .font(GroteskBold(30))
                                        .foregroundColor(Color(hex: 0xFFE03C))
                                    
                                    Text("\(colorHighScore)")
                                        .font(GroteskBold(30))
                                        .foregroundColor(Color(hex: 0xFFFAF1))
                                }
                                .offset(y: -7.5)
                            }
                            .zIndex(1)
                            
                            
                            RoundedRectangle(cornerRadius: 12, style:.continuous)
                                .zIndex(0.5)
                                .frame(width:256, height:160)
                                .foregroundColor(Color(hex: 0xEF652A))
                                .offset(y: 5)
                        }//Zstack1
                        .offset(y:0)
                        
                    }
                }//Zstack2
                .offset(y: -10)
                    .onAppear{
                        withAnimation (
                            .linear(duration:4).repeatForever(autoreverses:false)) {rotation = 360}
                }
                
            }
            .zIndex(3)
            .offset(y: 75)
            .padding(.top)
            
            Rectangle()
                .zIndex(3)
                .frame(width: 50, height: 50)
                .opacity(0)
                .contentShape(Rectangle())
                .position(x: 112, y: 650)
                .onTapGesture {
                    playButtonClickSound()
                    generator.prepare()
                    generator.impactOccurred()
                    toggleMode.toggle()
                }
                
            Rectangle()
                .zIndex(3)
                .frame(width: 50, height: 50)
                .opacity(0)
                .contentShape(Rectangle())
                .position(x: 112, y: 740)
                .onTapGesture {
                    playButtonClickSound()
                    generator.prepare()
                    generator.impactOccurred()
                    toggleMode.toggle()
                }
            Rectangle()
                .zIndex(3)
                .frame(width: 50, height: 50)
                .opacity(0)
                .contentShape(Rectangle())
                .foregroundColor(Color.orange.opacity(1.0))
                .position(x: 335, y: 645)
                .onTapGesture {
                    playButtonClickSound()
                    generator.prepare()
                    generator.impactOccurred()
                    if toggleMode && !tapped{
                        tapped = true
                        startGameToggle.toggle()
                    }else if !toggleMode && !tapped{
                        tapped = true
                        startGameToggle.toggle()
                    }
                }
        }
        .padding()
    }
    
    func playButtonClickSound(){
        let randNum = Int.random(in: 0...3)
        switch randNum{
        case 0:
            soundManager.playSound(soundName: "Button1", type: "mp3", duration: 1)
        case 1:
            soundManager.playSound(soundName: "Button2", type: "mp3", duration: 1)
        case 2:
            soundManager.playSound(soundName: "Button3", type: "mp3", duration: 1)
        case 3:
            soundManager.playSound(soundName: "Button4", type: "mp3", duration: 1)
        default:
            break
        }
    }
}
