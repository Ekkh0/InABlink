//
//  ColorGrid.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 28/04/24.
//

import SwiftUI

struct ColorGrid: View {
    @StateObject public var blinkDetection = BlinkDetection()
    @State private var arSessionManager: ARSessionManager?
    @State private var circles: [[CircleData]] = []
    @State private var correctCircleRow = 0
    @State private var correctCircleColumn = 0
    @State private var rotationDegrees = 0.0
    @Binding var roundWon : Bool
    @Binding var roundLost : Bool
    @Binding var difficulty : Int
    @State var winOrLose : Bool = false
    //    @State private var gridCount = 2 + self.difficulty // Initial grid size
    var gridCount: Int{
        return 2 + self.difficulty/4<8 ? 2 + self.difficulty/4 : 8
    }
    
    var body: some View {
        ZStack{
            GeometryReader{geometry in
                VStack(spacing: 0){
                    ForEach(0..<circles.count, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<self.circles[row].count, id: \.self) { column in
                                Circle()
                                    .foregroundColor(self.circles[row][column].color)
                                    .frame(width: (geometry.size.width - CGFloat(gridCount * 10)) / CGFloat(gridCount), height: (geometry.size.height - CGFloat(gridCount * 10)) / CGFloat(gridCount))
                                    .rotationEffect(Angle.degrees(self.rotationDegrees))
                                    .onTapGesture {
                                        if row == self.correctCircleRow && column == self.correctCircleColumn {
                                            roundWon.toggle()
                                            difficulty+=1
                                            winOrLose = true
                                            generateGrid()
                                        } else {
                                            winOrLose = false
                                            roundLost.toggle()
                                        }
                                    }
                                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                                    .padding(5)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .onAppear(){
                    generateGrid()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: blinkDetection.didBlink) {
                    if blinkDetection.didBlink{
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                        generateGrid()
                    }
                }
            }
            //            EffectView(correct: $winOrLose)
        }
        .onAppear {
            arSessionManager = ARSessionManager(blinkDetection: blinkDetection)
        }
        .onDisappear {
            // Pause the AR session when the view disappears
            arSessionManager?.pause()
        }
    }
    
    func generateGrid() {
        circles = []
        var colors: [Color] = [.red, .green, .blue, .yellow, .cyan]
        var randInt = Int.random(in: 0...4)
        if (gridCount>4){
            colors = [.orange, .blue, .yellow, .cyan, Color("Lilac"), Color("LilacLight")]
            randInt = Int.random(in: 0...5)
        }
        let differentColorIndex = Int.random(in: 0..<gridCount * gridCount)
        let color = colors[randInt]
        colors.remove(at: randInt)
        let color2 = colors.randomElement()!
    
        for row in 0..<gridCount {
            var rowCircles: [CircleData] = []
            for column in 0..<gridCount {
                if row * gridCount + column == differentColorIndex {
                    // Set one circle with a different color
                    rowCircles.append(CircleData(color: color))
                } else {
                    rowCircles.append(CircleData(color: color2))
                }
            }
            circles.append(rowCircles)
        }
        
        // Set correct circle position
        correctCircleRow = differentColorIndex / gridCount
        correctCircleColumn = differentColorIndex % gridCount
    }
}

struct CircleData {
    var color: Color
}
