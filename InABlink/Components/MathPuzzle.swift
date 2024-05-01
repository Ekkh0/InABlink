//
//  MathPuzzle.swift
//  InABlink
//
//  Created by Putri Wulandari Oktaviani on 01/05/24.
//

import SwiftUI

struct MathPuzzle: View {
    @State private var firstNum:Int = 0
    @State private var secondNum:Int = 0
    @State private var thirdNum:Int = 0
    @State private var correctAns1:Int = 0
  
    @State private var choiceArray:[Int] = [0,1,2,3,4,5,6,7,8,9]
    @State private var buttonColor : [Color] = [Color(hex: 0xEF652A), Color(hex: 0xF9B532),Color(hex: 0x3968AF),Color(hex: 0xF9B532),Color(hex: 0x3968AF),Color(hex: 0xEF652A),Color(hex: 0x3968AF),Color(hex: 0xEF652A),Color(hex: 0xF9B532)]
    @State private var score = 0
    
    
    
    
    func Soal1(){
        var pilihanJawaban = [Int]()
        firstNum = Int.random(in: 0...15)
        secondNum = Int.random(in: 0...15)
        thirdNum = Int.random(in: 0...15)
        
        correctAns1=firstNum*secondNum-thirdNum
        
        for _ in 0...7 {
            pilihanJawaban.append(Int.random(in: 0...225))
        }//iterasi jawaban
        
        pilihanJawaban.append(correctAns1)
        choiceArray = pilihanJawaban.shuffled()
    }//Soal1
    
    func ansIsCorrect(answer : Int) {
        
        if answer == correctAns1 {
            score = score + 1
        } else {
            score = score - 1
        }
        
    }//ansIsCorrect
    
    var body: some View {
        VStack {
            
            HStack {
                //BACK CHEVRON
                Image(systemName: "chevron.backward")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                //SCORING
                Text("\(score)")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .offset(y: -60)
            
            
           
                            
            
            
            //SOAL
            ZStack {
                Rectangle()
                    .frame(width:350, height:200)
                    .cornerRadius(30)
                    .foregroundColor(Color(hex: 0xEF652A))
                
                //TIMER
                VStack {
                    Image(systemName: "timer")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .offset(y:-80)
                    
                    
                    Text("\(firstNum) ✖️ \(secondNum) ➖ \(thirdNum)")
                        .font(.system(size: 50))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(hex: 0xFFFAF1))
                }
                
            }
                .offset(y : -10)
            
            //ANSWER TILE
            VStack {
                HStack {
                    ForEach (0..<3){ index in Button {
                        ansIsCorrect(answer : choiceArray[index])
                        Soal1()
                    } label: {
                        AnswerTile(number: choiceArray[index])
                        
                    }
                        
                    .frame(width: 80,height: 80, alignment: .center)
                    .background(buttonColor[index])
                    .cornerRadius(10)
                    .padding(10.0)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    }//foreachjawaban
                }
                
                
                HStack {
                    ForEach (3..<6){ index in Button {
                        ansIsCorrect(answer : choiceArray[index])
                        Soal1()
                    } label: {
                        AnswerTile(number: choiceArray[index])
                        
                    }
                        
                    .frame(width: 80,height: 80, alignment: .center)
                    .background(buttonColor[index])
                    .cornerRadius(10)
                    .padding(10.0)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    }//foreachjawaban
                }
                
                HStack {
                    ForEach (6..<9){ index in Button {
                        ansIsCorrect(answer : choiceArray[index])
                        Soal1()
                    } label: {
                        AnswerTile(number: choiceArray[index])
                        
                    }
                        
                    .frame(width: 80,height: 80, alignment: .center)
                    .background(buttonColor[index])
                    .cornerRadius(10)
                    .padding(10.0)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    }//foreachjawaban
                }
            }
            .offset(y:0)
            
        }
        .onAppear(perform: {
            Soal1()
        })
        .padding()
    }
}

#Preview {
    MathPuzzle()
}
