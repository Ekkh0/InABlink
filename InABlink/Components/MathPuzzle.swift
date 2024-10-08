//
//  ColorGrid.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 28/04/24.
//

import SwiftUI

struct MathPuzzle: View {
    @StateObject public var blinkDetection = BlinkDetection()
    @State private var arSessionManager: ARSessionManager?
    @State private var circles: [[CircleDataMath]] = []
    @State private var correctCircleRow = 0
    @State private var correctCircleColumn = 0
    @State private var rotationDegrees = 0.0
    @Binding var roundWon : Bool
    @Binding var roundLost : Bool
    @Binding var difficulty : Int
    //    @StateObject public var mathQuiz = MathQuiz(difficulty: 0)
    @State var winOrLose : Bool = false
    @State var equation: String = ""
//    @State var answers: [Int] = []
    @State var numbersMem: [Int] = []
    @State var operators: [Int] = []
    @State var numElement: Int = 0
    @State var answerCorrect: Int = 0
    //    @State private var gridCount = 2 + self.difficulty // Initial grid size
    var gridCount: Int{
        return 2 + self.difficulty/4<6 ? 2 + self.difficulty/4 : 6
    }
    
    var body: some View {
        ZStack{
            GeometryReader{geometry in
                VStack(spacing: 0){
                    VStack(alignment: .center){
                        Text("\(equation)")
                            .foregroundColor(.background)
                            .font(GroteskBold(25))
                            .padding(.top, 90)
                    }
                    .frame(width: geometry.size.width, height: 200)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.bottom, 35)
                    ForEach(0..<circles.count, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<self.circles[row].count, id: \.self) { column in
                                ZStack{
                                    Text("\(self.circles[row][column].num)")
                                        .zIndex(2)
                                        .font(GroteskBold((geometry.size.height - CGFloat(gridCount * 10)) / CGFloat(gridCount) * 0.3))
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(self.circles[row][column].color)
                                        .frame(width: (geometry.size.width - CGFloat(gridCount * 10)) / CGFloat(gridCount), height: (geometry.size.height - CGFloat(gridCount * 10)) / CGFloat(gridCount))
                                        .rotationEffect(Angle.degrees(self.rotationDegrees))
                                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 3)
                                        .padding(5)
                                        .zIndex(1)
                                }
                                .onTapGesture {
                                    if row == self.correctCircleRow && column == self.correctCircleColumn {
                                        roundWon.toggle()
                                        difficulty+=1
                                        winOrLose = true
                                        generateMathQuiz()
                                        generateGrid()
                                    } else {
                                        winOrLose = false
                                        roundLost.toggle()
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .onAppear(){
                    generateMathQuiz()
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
        let colors: [Color] = [.red, .green, .blue, .yellow, .cyan, .orange, .blue, .yellow, .cyan, Color("Lilac"), Color("LilacLight")]
        let correctNumberIndex = Int.random(in: 0..<gridCount * gridCount)
        
        var randNum = 0
        
        for row in 0..<gridCount {
            var rowCircles: [CircleDataMath] = []
            for column in 0..<gridCount {
                if row * gridCount + column == correctNumberIndex {
                    // Set one circle with a different color
                    rowCircles.append(CircleDataMath(color: colors[Int.random(in: 0...10)], num: answerCorrect))
                } else {
                    if answerCorrect != 0 && answerCorrect > 0{
                        repeat{
                            randNum = Int.random(in: -abs(answerCorrect)...abs(answerCorrect*2))
                        }while randNum==answerCorrect
                    }else if answerCorrect != 0 && answerCorrect < 0{
                        repeat{
                            randNum = Int.random(in: -abs(answerCorrect*2)...abs(answerCorrect))
                        }while randNum==answerCorrect
                    }else{
                        randNum = Int.random(in: -100...100)
                    }
                    
                    rowCircles.append(CircleDataMath(color: colors[Int.random(in: 0...10)], num: randNum))
                }
            }
            circles.append(rowCircles)
        }
        
        // Set correct circle position
        correctCircleRow = correctNumberIndex / gridCount
        correctCircleColumn = correctNumberIndex % gridCount
    }
    
    func findFactors(of number: Int) -> Int {
        guard number > 0 else { return 1 } // Ensure the number is positive
        
        var factors: [Int] = []
        
        // Iterate from 1 to the square root of the number
        for i in 1...Int(Double(number).squareRoot()) {
            if number % i == 0 {
                factors.append(i) // Add the factor
                if i != number / i { // Ensure we don't add duplicate factors for perfect squares
                    factors.append(number / i) // Add the corresponding factor
                }
            }
        }
        
        return factors.randomElement() ?? 1 // Sort the factors in ascending order
    }
    
    func generateMathQuiz(){
        //how many number in the math quiz -> below 2 = 2-4
        equation = ""
//        answers = []
        var minNumber = difficulty/3 > 2 ? difficulty/3-2 : 0
        
        if minNumber > 2{
            minNumber = 2
        }
        
        var maxNumber = difficulty/3
        
        if maxNumber > 2{
            maxNumber = 2
        }
        
        let numElementTemp = Int.random(in:
                                            (2+minNumber)
                                        ...
                                        (2+maxNumber))
        operators = []
        var numbers: [Int] = []
        //generate + - x :
        for _ in 0..<numElementTemp-1{
            operators.append(Int.random(in: 0...3))
        }
        
        for _ in 0..<numElementTemp{
            numbers.append(Int.random(in: 0...10+difficulty/3*10))
        }
        
        //ensures the division is always round
        for i in 0..<numElementTemp-1{
            if operators[i] == 3{
                numbers[i+1] = findFactors(of: numbers[i])
            }
        }
        
        numbersMem = numbers
        numElement = numElementTemp
        
        var a = 0
        
        
        for i in 0..<numElementTemp-1{
            switch operators[i]{
            case 2:
//                print("Menghitung: \(numbers[a])*\(numbers[a+1])")
                numbers[a] = numbers[a]*numbers[a+1]
//                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            case 3:
//                print("Menghitung: \(numbers[a])/\(numbers[a+1])")
                if numbers[a+1] == 0{
                    operators[i] = Int.random(in: 0...1)
                    a+=1
                    break
                }
                numbers[a] = numbers[a]/numbers[a+1]
//                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            default:
                a+=1
            }
        }
        
        a=0
        
        for i in 0..<numElementTemp-1{
            switch operators[i]{
            case 0:
//                print("Menghitung: \(numbers[a])+\(numbers[a+1])")
                numbers[a] = numbers[a]+numbers[a+1]
//                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            case 1:
//                print("Menghitung: \(numbers[a])-\(numbers[a+1])")
                numbers[a] = numbers[a]-numbers[a+1]
//                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            default:
                break
            }
        }
        
//        print(numbersMem, operators)
        
//        print(numbers)
        
        answerCorrect = numbers[0]
        
//        for _ in 0..<gridCount*gridCount{
//            var randNum = 0
//            
//            repeat{
//                randNum = Int.random(in: -abs(numbers[0])...abs(numbers[0]*2))
//            }while randNum==answerCorrect
//            
//            answers.append(randNum)
//        }
        
        for i in 0..<numElement-1{
            equation.append(String(numbersMem[i]))
            switch operators[i]{
            case 0:
                equation.append(" + ")
            case 1:
                equation.append(" - ")
            case 2:
                equation.append(" * ")
            case 3:
                equation.append(" / ")
            default:
                break
            }
        }
        
        equation.append(String(numbersMem.last!))
        equation.append(" =")
        
//        print(equation)
        
        return
    }
}

struct CircleDataMath {
    var color: Color
    var num: Int
}
