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
    @State private var timeRemaining = 60
    @State private var timeTotal = 60
    @State private var timer: Timer?
    @State var difficulty : Int = 0
    @State var colorScores: [Int] = UserDefaults.standard.array(forKey: "colorScoreMem") as? [Int] ?? []
    @State var mathScores: [Int] = UserDefaults.standard.array(forKey: "mathScoreMem") as? [Int] ?? []
    @State private var isCounting = true
    @State var isLoadingDone: Bool = false
    @State var loadingScreen: Bool = false
    @State var timesUpScreen: Bool = false
    @State var startGameToggle: Bool = false
    @State var tapped: Bool = false
    @State var isRevealSpalshScreenDone: Bool = false
    @StateObject var soundManager = SoundManager()
    @State var toggleMode: Bool = false
    
    var body: some View {
        VStack {
            ZStack{
//                SplashScreenView()
//                    .zIndex(4)
//                    .opacity(isRevealSpalshScreenDone ? 0 : 1)
//                    .ignoresSafeArea()
//                    .onAppear{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
//                            isRevealSpalshScreenDone.toggle()
//                        }
//                    }
                if loadingScreen{
                    PulsingCircle()
                        .zIndex(2)
                        .onAppear{
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                withAnimation {
                                    self.isLoadingDone = true
                                }
                            }
                        }
                }
                //                .frame(width: 300, height: 500)
                //                .onChange(of: blinkDetection.didBlink) {
                //                    if blinkDetection.didBlink {
                //                        generateGrid()
                //                    }
                //                }
                if isGameRunning {
                    ZStack{
                        if isLoadingDone{
                            VStack(alignment: .center){
                                ZStack(alignment: .top){
                                    HStack(alignment: .center){
                                        Image(systemName: "chevron.left")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 30)
                                            .foregroundColor(.orange)
                                            .shadow(radius: 2, y: 2)
                                            .onTapGesture {
                                                soundManager.stopPlayback()
                                                resetTimer()
                                                endGame()
                                            }
                                    }
                                    .frame(height: 30)
                                    .offset(x: -175, y: 15)
                                        
                                    ZStack {
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .foregroundColor(.background)
                                            .frame(width: 230, height: 230)
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .fill(.shadow(.inner(radius: 5)))
                                            .foregroundColor(Color.background)
                                            .frame(width: 200, height: 200)
                                        Circle()
                                            .trim(from: 0, to: CGFloat(Double(timeRemaining) / Double(timeTotal)))
                                            .stroke(.orange, lineWidth: 25)
                                            .frame(width: 175, height: 175)
                                            .rotationEffect(.degrees(-90))
                                            .animation(.linear(duration: 1))
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .foregroundColor(.background)
                                            .shadow(radius: 5, y: 2)
                                            .frame(width: 150, height: 150)
                                        VStack(alignment: .center, spacing: 0){
                                            Text("\(timeRemaining)")
                                                .foregroundColor(.orange)
                                                .font(GroteskBold(40))
                                                .padding(0)
                                            HStack(alignment: .center, spacing: 0){
                                                Image(systemName: "checkmark.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(Color(hex: 0xFFE03C))
                                                    .frame(height: 25)
                                                    .shadow(radius: 1, y: 2)
                                                    .padding(.trailing, 3)
                                                Text("\(score)")
                                                    .font(GroteskBold(25))
                                                    .foregroundColor(.orange)
                                                    .frame(height: 40)
                                            }
                                            .frame(width: 100, height: 30)
//                                            .offset(x: 130, y:15)
                                        }
                                    }
                                    .padding()
                                }
                                .zIndex(1)
                                //                                .padding([.leading, .trailing], 20)
                                if !toggleMode{
                                    GeometryReader{ geometry in
                                        MathPuzzle(roundWon: $roundWon, roundLost: $roundLost, difficulty: $difficulty)
                                            .onChange(of: roundWon) {
                                                nextRound()
                                            }
                                            .onChange(of: roundLost) {
                                                punishment()
                                            }
                                            .frame(width: .infinity, height: geometry.size.width)
                                    }
                                    .offset(y: -125)
                                    .zIndex(0.2)
                                }else{
                                    GeometryReader{ geometry in
                                        ColorGrid(roundWon: $roundWon, roundLost: $roundLost, difficulty: $difficulty)
                                            .onChange(of: roundWon) {
                                                nextRound()
                                            }
                                            .onChange(of: roundLost) {
                                                punishment()
                                            }
                                            .frame(width: .infinity, height: geometry.size.width)
                                    }
                                }
                            }
                            .padding([.leading, .trailing, .bottom], 20)
                        }
                        
                    }
                    //                .onChange(of: blinkDetection.didBlink) {
                    //                    if blinkDetection.didBlink {
                    //                        generateGrid()
                    //                    }
                    //                }
                } else {
                    VStack {
                        MenuView(toggleMode: $toggleMode, mathHighScore: mathScores.max() ?? 0, colorHighScore: colorScores.max() ?? 0, startGameToggle: $startGameToggle, tapped: $tapped)
                            .onChange(of: startGameToggle) {
                                if startGameToggle{
                                    tapped.toggle()
                                    startGame()
                                }
                            }
                    }
                }
                
                if timesUpScreen{
                    timesUp()
                        .onAppear{
                            soundManager.stopPlayback()
                            soundManager.playSound(soundName: "Alarm", type: "wav", duration: 5)
                            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                                resetTimer()
                                endGame()
                            }
                        }
                }
                
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func startGame() {
        loadingScreen.toggle()
        soundManager.playSound(soundName: "Falling", type: "mp3", duration: 4)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            timesUpScreen = false
            isGameRunning = true
            score = 0
            if !toggleMode{
                timeRemaining = 300
                timeTotal = 300
            }else{
                timeRemaining = 60
                timeTotal = 60
            }
            startTimer()
        }
    }
    
    func nextRound() {
        if !toggleMode{
            score += 1
        }else{
            score += timeTotal - timeRemaining // Score based on remaining time
        }
    }
    
    func punishment(){
        timeRemaining -= 5
        if(timeRemaining<0){
            timeRemaining = 0
            timesUpScreen = true
        }
    }
    
    func endGame() {
        //        gridCount = 2
        isGameRunning = false
        difficulty = 0
        tapped = false
        startGameToggle = false
        print(tapped)
        
        if !toggleMode{
            mathScores.append(score)
            UserDefaults.standard.set(colorScores, forKey: "mathScoreMem")
        }else{
            colorScores.append(score)
            UserDefaults.standard.set(colorScores, forKey: "colorScoreMem")
        }
        
        isLoadingDone.toggle()
        loadingScreen.toggle()
    }
    
    func startTimer() {
        var togglePlayed = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining <= 15 && !togglePlayed{
                timeRemaining -= 1
                togglePlayed = true
                soundManager.playSound(soundName: "Timer", type: "wav", duration: 15)
                print("Terjalan timer!")
            }else if timeRemaining > 0{
                timeRemaining -= 1
            }else {
                timesUpScreen = true
            }
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview{
    GameView()
}
