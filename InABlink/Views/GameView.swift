//
//  ContentView.swift
//  Nano1-FindColorGame
//
//  Created by Jaqueline Aurelia Langi on 26/04/24.
//

import SwiftUI

struct GameView: View {
    @State private var isGameRunning = false
    @State var roundWon: Bool = false
    @State var roundLost: Bool = false
    @State private var score = 0
    @State private var highScore = UserDefaults.standard.integer(forKey: "highScore")
    @State private var timeRemaining = 30
    @State private var timer: Timer?
    @State var difficulty : Int = 0
    
    var body: some View {
        VStack {
            Text("In A Blink")
                .font(.title)
                .padding()
            
            if isGameRunning {
                VStack {
                    ColorGrid(roundWon: $roundWon, roundLost: $roundLost, difficulty: $difficulty)
                        .onChange(of: roundWon) {
                            nextRound()
                        }
                        .onChange(of: roundLost) {
                            punishment()
                        }
                }
                .padding()
//                .onChange(of: blinkDetection.didBlink) {
//                    if blinkDetection.didBlink {
//                        generateGrid()
//                    }
//                }
            } else {
                VStack {
                    Image(systemName: "eye")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Button(action: startGame) {
                        Image(systemName: "arrowshape.right")
                            .font(.system(size: 100))
                            .frame(width: 250, height: 125)
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                            }
                    }
                }
            }
            
            Text("Score: \(score)")
            Text("High Score: \(highScore)")
            Text("Time: \(timeRemaining)")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func startGame() {
        isGameRunning = true
        score = 0
        timeRemaining = 30
        startTimer()
//        generateGrid()
    }
    
    func nextRound() {
        score += timeRemaining // Score based on remaining time
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
        
//        generateGrid()
    }
    
    func punishment(){
        timeRemaining -= 5
        if(timeRemaining<0){
            timeRemaining = 0
            endGame()
        }
    }
    
    func endGame() {
//        gridCount = 2
        isGameRunning = false
        resetTimer()
        difficulty = 0
//        print(gridCount)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame()
            }
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
