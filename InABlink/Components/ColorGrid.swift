//
//  ColorGrid.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 28/04/24.
//

import SwiftUI

struct ColorGrid: View {
    @StateObject public var blinkDetection = FaceDetectionViewController()
    @State private var circles: [[CircleData]] = []
    @State private var correctCircleRow = 0
    @State private var correctCircleColumn = 0
    @State private var rotationDegrees = 0.0
    @Binding var roundWon : Bool
    @Binding var roundLost : Bool
    @Binding var difficulty : Int
//    @State private var gridCount = 2 + self.difficulty // Initial grid size
    var gridCount: Int{
        return 2 + self.difficulty
    }
//    @Binding var didBlink : Bool
    
    var body: some View {
        VStack{
            ForEach(0..<circles.count, id: \.self) { row in
                HStack {
                    ForEach(0..<self.circles[row].count, id: \.self) { column in
                        Circle()
                            .foregroundColor(self.circles[row][column].color)
                            .frame(width: 50, height: 50)
                            .rotationEffect(Angle.degrees(self.rotationDegrees))
                            .onTapGesture {
                                if row == self.correctCircleRow && column == self.correctCircleColumn {
                                    roundWon.toggle()
                                    difficulty+=1
                                    generateGrid()
                                } else {
                                    roundLost.toggle()
                                }
                            }
                    }
                }
            }
        }
        .onAppear(){
            generateGrid()
        }
        .onChange(of: blinkDetection.didBlink) {
            generateGrid()
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
        print("Terjalan!")
        
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
