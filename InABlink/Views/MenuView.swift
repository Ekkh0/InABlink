//
//  ContentView.swift
//  InABlinkUI
//
//  Created by Putri Wulandari Oktaviani on 29/04/24.
//

import SwiftUI

func buttonPressed() {
    print("buttonpressed")
}

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
    @State var toggleMode: Bool = false
    @State var highScore: Int = 0
    @Binding var startGameToggle: Bool
    @Binding var tapped: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Image( "Home Screen")
                .zIndex(1)
                .scaledToFit()
                .ignoresSafeArea()
            VStack  {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style:.continuous)
                        .frame(width:256, height:150)
                        .foregroundColor(Color(hex: 0xEF652A))
                    VStack {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .opacity(!toggleMode ? 1: 0)
                                .frame(width:300, height:118)
                            
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red,.red,.orange, .orange,.blue,.blue]), startPoint: .top, endPoint: .bottom))
                                .rotationEffect(.degrees(rotation))
                                .mask{
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .frame(width:266, height:118)
                                }
                            Image("math game")
                                .onTapGesture {
                                }
                        }//Zstack1
                        
                        .offset(y:0)
                        
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color(hex: 0xFFE03C))
                            
                            Text("81")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color(hex: 0xFFFAF1))
                                
                        }
                        .offset(y:-18)
                    }
                }//Zstack2
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style:.continuous)
                        .frame(width:256, height:150)
                        .foregroundColor(Color(hex: 0xEF652A))
                    
                    VStack {
                        ZStack  {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .opacity(toggleMode ? 1: 0)
                                .frame(width:300, height:118)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red,.red,.orange, .orange,.blue,.blue]), startPoint: .top, endPoint: .bottom))
                                .rotationEffect(.degrees(rotation))
                                .mask{
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .frame(width:266, height:118)
                                }
                            
                            Image("color puzzle")
                                .onTapGesture {
                                    if !tapped{
                                        tapped=true
                                        startGameToggle.toggle()
                                    }
                                }
                                .padding (5)
                        }//Zstack
                        .offset(y:0)
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color(hex: 0xFFE03C))
                            
                            Text("\(highScore)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color(hex: 0xFFFAF1))
                                
                        }
                        .offset(y:-15)
                        
                    }
                    
                }
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
                    toggleMode.toggle()
                }
                
            Rectangle()
                .zIndex(3)
                .frame(width: 50, height: 50)
                .opacity(0)
                .contentShape(Rectangle())
                .position(x: 112, y: 740)
                .onTapGesture {
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
                    if toggleMode && !tapped{
                        tapped = true
                        startGameToggle.toggle()
                    }
                }
        }
        .padding()
        
    }
}
