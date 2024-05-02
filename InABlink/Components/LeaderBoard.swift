//
//  LeaderBoard.swift
//  InABlink
//
//  Created by Putri Wulandari Oktaviani on 02/05/24.
//

import SwiftUI

struct Pentagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Calculate the center of the pentagon
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Calculate the radius of the circle that circumscribes the pentagon
        let radius = min(rect.width, rect.height) / 2

        // Calculate the angle between each corner of the pentagon
        let angle = CGFloat.pi * 2 / 5

        // Start drawing the pentagon from the top corner
        let startAngle = -CGFloat.pi / 2

        // Move to the starting point of the pentagon
        path.move(to: CGPoint(x: center.x + radius * cos(startAngle), y: center.y + radius * sin(startAngle)))

        // Draw the lines to the other corners of the pentagon
        for i in 1...5 {
            let x = center.x + radius * cos(startAngle + angle * CGFloat(i))
            let y = center.y + radius * sin(startAngle + angle * CGFloat(i))
            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Close the path
        path.closeSubpath()

        return path
    }
}

struct LeaderBoard: View {
    @State private var rotation: Double = 0
    @Binding var scores: [Int]
    @Binding var score: Int
    var highScores: [Int]?{
        return scores.sorted(by: >)
    }
    @Binding var leaderboard: Bool
    
    var body: some View {
        VStack(alignment: .center){
            //CHEVRON BACK
            HStack(){
                Image(systemName: "chevron.backward")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    leaderboard.toggle()
                }
                Spacer()
            }
            .padding(.top, 100)
            .padding(.leading, 20)
            
            ZStack {
                Rectangle()
                    .frame(width:256,height:114)
                    .cornerRadius(18)
                .foregroundColor(Color(hex: 0xFFFAF1))
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                
                //SCORE
                HStack {
                    Text("\(score)")
                        .foregroundColor(Color(hex:0xEF652A))
                        .font(GroteskBold(54))
                        .fontWeight(.bold)
                        .padding(.trailing, 10)

                    Image("refresh arrow")
                }
            }
            .zIndex(3)
            .frame(width: 400)
            .offset(y:500)
            .onTapGesture {
                leaderboard.toggle()
            }
            
//            SCORE LADDER
            ZStack {
                HStack(alignment: .top, spacing: 0){
                    ZStack {
                        Rectangle()
                            .frame(width:116, height:635)
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: 0x3968AF))
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 5)
                        .offset(x:10,y:45)
                        
                        
                        //2ND BEST SOCRE
                        VStack(alignment: .center) {
                            Text("\(highScores?[1] ?? 0)")
                                .foregroundColor(Color(hex:0xFFFAF1))
                                .font(GroteskBold(36))
                                .fontWeight(.bold)
                            
                            Pentagon()
                                .frame(width: 98, height: 98)
                                .foregroundColor(Color(hex:0x2B518C))
                                .rotationEffect(.degrees(rotation))
                                .onAppear {
                                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                                    self.rotation = 360 // Rotate 360 degrees
                                                }
                                            }
                                .overlay{
                                    Text("2")
                                        .foregroundColor(Color(hex:0xFFFAF1))
                                        .font(GroteskBold(54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:70,y:170)
                    }
                    .zIndex(2)
                        
                        
                    
                    
                    ZStack {
                        Rectangle()
                            .frame(width:140, height:680)
                            .cornerRadius(10)
                        .foregroundColor(Color(hex: 0xEF652A))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        //1st BEST SOCRE
                        VStack(alignment: .center) {
                            Text("\(highScores?[0] ?? 0)")
                                .foregroundColor(Color(hex:0xFFFAF1))
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                            
                            Pentagon()
                                .frame(width: 115, height: 115)
                                .foregroundColor(Color(hex:0xBD4715))
                                .rotationEffect(.degrees(rotation))
                                .onAppear {
                                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                                    self.rotation = 360 // Rotate 360 degrees
                                                }
                                            }
                                .overlay{
                                    Text("1")
                                        .foregroundColor(Color(hex:0xFFFAF1))
                                        .font(GroteskBold(54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:70,y:130)
                    }
                    .zIndex(3)
                    
                    ZStack {
                        Rectangle()
                            .frame(width:116, height:590)
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: 0xF9B532))
                        .offset(x:-10,y: 90)
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 5)
                        
                        //3RD BEST SOCRE
                        VStack(alignment: .center) {
                            Text("\(highScores?[2] ?? 0)")
                                .foregroundColor(Color(hex:0xFFFAF1))
                                .font(GroteskBold(36))
                                .fontWeight(.bold)
                            
                            Pentagon()
                                .frame(width: 98, height: 98)
                                .foregroundColor(Color(hex:0xCD9827))
                                .rotationEffect(.degrees(rotation))
                                .onAppear {
                                                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                                    self.rotation = 360 // Rotate 360 degrees
                                                }
                                            }
                                .overlay{
                                    Text("3")
                                        .foregroundColor(Color(hex:0xFFFAF1))
                                        .font(GroteskBold(54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:55,y:210)
                    }
                    .zIndex(1)
                }
                .offset(y:-60)
                
                //SCORE TERKINI
            }
            .zIndex(1)
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .frame(height: UIScreen.main.bounds.size.height)
        .background(Color.background)
    }
        
}
