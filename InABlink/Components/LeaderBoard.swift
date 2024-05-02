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
        var startAngle = -CGFloat.pi / 2

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
    var body: some View {
        VStack{
            //CHEVRON BACK
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                .fontWeight(.bold)
            
                Spacer()
            }
            
            Spacer()
            
            
            
            //SCORE LADDER
            ZStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width:116, height:635)
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: 0x3968AF))
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 5)
                        .offset(x:10,y:40)
                        
                        
                        //2ND BEST SOCRE
                        VStack {
                            Text("1910")
                                .foregroundColor(Color(hex:0xFFFAF1))
                                .font(.system(size: 36))
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
                                        .font(.system(size: 54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:70,y:200)
                        
                    }
                        
                        
                    
                    
                    ZStack {
                        Rectangle()
                            .frame(width:140, height:680)
                            .cornerRadius(10)
                        .foregroundColor(Color(hex: 0xEF652A))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        //1st BEST SOCRE
                        VStack {
                            Text("1919")
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
                                        .font(.system(size: 54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:70,y:130)
                    }
                    
                    
                    ZStack {
                        Rectangle()
                            .frame(width:116, height:590)
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: 0xF9B532))
                        .offset(x:-8,y: 90)
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 5)
                        
                        //3RD BEST SOCRE
                        VStack {
                            Text("1907")
                                .foregroundColor(Color(hex:0xFFFAF1))
                                .font(.system(size: 36))
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
                                        .font(.system(size: 54))
                                        .fontWeight(.bold)
                            }
                                
                        }
                        .position(x:50,y:250)
                    }
                }
                .offset(y:60)
                
               
                
                
                //SCORE TERKINI
                ZStack {
                    Rectangle()
                        .frame(width:256,height:114)
                        .cornerRadius(18)
                    .foregroundColor(Color(hex: 0xFFFAF1))
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                    
                    //SCORE
                    HStack {
                        Text("1906")
                            .foregroundColor(Color(hex:0xEF652A))
                            .font(.system(size: 54))
                            .fontWeight(.bold)
                        
                        
                        Image("refresh arrow")
                    }
                }
                .position(x:190,y:500)
                    
            }
            
        }
        .padding(.horizontal)
    }
        
}


#Preview {
    LeaderBoard()
}
