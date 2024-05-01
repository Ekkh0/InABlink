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
    @State var scores: [Int] = UserDefaults.standard.array(forKey: "scoreMem") as? [Int] ?? []
    @State private var isCounting = true
    @State var isLoadingDone: Bool = false
    @State var loadingScreen: Bool = false
    @State var timesUpScreen: Bool = false
    @State var startGameToggle: Bool = false
    @State var tapped: Bool = false
    @State var isRevealSpalshScreenDone: Bool = false
    @StateObject var soundManager = SoundManager()
    
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
                                HStack(alignment: .top){
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
                                    ZStack {
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
                                        Text("\(timeRemaining)")
                                            .foregroundColor(.orange)
                                            .font(GroteskBold(50))
                                            .padding()
                                    }
                                    .padding()
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 60, height: 60)
                                }
                                //                                .padding([.leading, .trailing], 20)
                                Spacer()
                                HStack(alignment: .center){
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color(hex: 0xFFE03C))
                                        .frame(height: 40)
                                        .shadow(radius: 1, y: 2)
                                    Text("\(score)")
                                        .font(GroteskBold(30))
                                        .foregroundColor(.orange)
                                        .frame(height: 40)
                                }
                                .frame(height: 75)
                                Spacer()
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
//                                .padding(.bottom, 20)
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
                        MenuView(highScore: scores.max() ?? 0, startGameToggle: $startGameToggle, tapped: $tapped)
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
            timeRemaining = 60
            startTimer()
        }
    }
    
    func nextRound() {
        score += timeTotal - timeRemaining // Score based on remaining time
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
        
        scores.append(score)
        UserDefaults.standard.set(scores, forKey: "scoreMem")
        
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
