//
//  MathQuiz.swift
//  InABlink
//
//  Created by Dharmawan Ruslan on 28/04/24.
//

import SwiftUI

struct MathQuiz: View {
    var equation: String = ""
    @State var difficulty: Int = 0
    @State var answers: [Int] = []
    @State var numbersMem: [Int] = []
    @State var operators: [Int] = []
    @State var numElement: Int = 0
    @State var tiles: [Tile] = []
    
//    func findFactors(of number: Int) -> [Int] {
//        guard number > 0 else { return [] } // Ensure the number is positive
//        
//        var factors: [Int] = []
//        
//        // Iterate from 1 to the square root of the number
//        for i in 1...Int(Double(number).squareRoot()) {
//            if number % i == 0 {
//                factors.append(i) // Add the factor
//                if i != number / i { // Ensure we don't add duplicate factors for perfect squares
//                    factors.append(number / i) // Add the corresponding factor
//                }
//            }
//        }
//        
//        factors.sort() // Sort the factors in ascending order
//        
//        return factors
//    }
    
    func generateMathQuiz(){
        //how many number in the math quiz -> below 2 = 2-4
        let numElementTemp = Int.random(in:
                                            (2+((difficulty>2 ? difficulty-2 : 0)>2 ? difficulty : 2))
                                        ...
                                        (difficulty>2 ? 2+difficulty : 4))
        operators = []
        var numbers: [Int] = []
        //generate + - x :
        for _ in 0..<numElementTemp-1{
            operators.append(Int.random(in: 0...3))
        }
        
        for _ in 0..<numElementTemp{
            numbers.append(Int.random(in: 0...10+difficulty*10))
        }
        
        numbersMem = numbers
        numElement = numElementTemp
        
        var a = 0
        
        for i in 0..<numElementTemp-1{
            switch operators[i]{
            case 2:
                print("Menghitung: \(numbers[a])*\(numbers[a+1])")
                numbers[a] = numbers[a]*numbers[a+1]
                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            case 3:
                print("Menghitung: \(numbers[a])/\(numbers[a+1])")
                if numbers[a+1] == 0{
                    operators[i] = Int.random(in: 0...1)
                    a+=1
                    break
                }
                numbers[a] = numbers[a]/numbers[a+1]
                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            default:
                a+=1
            }
        }
        
        a=0
        
        for i in 0..<numElementTemp-1{
            switch operators[i]{
            case 0:
                print("Menghitung: \(numbers[a])+\(numbers[a+1])")
                numbers[a] = numbers[a]+numbers[a+1]
                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            case 1:
                print("Menghitung: \(numbers[a])-\(numbers[a+1])")
                numbers[a] = numbers[a]-numbers[a+1]
                print("telah terhitung \(numbers[a])")
                numbers.remove(at: a+1)
            default:
                break
            }
        }
        
        print(numbersMem, operators)
        
        print(numbers)
        
        answers.append(numbers[0])
                tiles.append(Tile(locationPiece: CGPoint(x: Int(arc4random()%1000), y: Int(arc4random()%1000)), index: 0, number: answers[0]))
        
        for i in 0..<3+difficulty{
            answers.append(Int.random(in: -abs(numbers[0])...abs(numbers[0]*2)))
                        tiles.append(Tile(locationPiece: CGPoint(x: Int(arc4random()%1000), y: Int(arc4random()%1000)), index: i+1, number: answers[i]))
        }
        
        print("X")
        print(tiles.count)
        
        return
    }
    
//    init(){
//        generateMathQuiz()
//    }
    
    var body: some View {
        VStack{
            Text("Hello World!")
//            ZStack{
//                ForEach (0..<2, id: \.self){i in
//                    AnswerTile(tile: $tiles[i])
//                }
//            }
        }
//        onAppear(){
//            generateMathQuiz()
//        }
    }
}

class Tile{
    var id = UUID()
    var locationPiece: CGPoint
    var index: Int
    var number: Int
    
    init(id: UUID = UUID(), locationPiece: CGPoint, index: Int, number: Int) {
        self.id = id
        self.locationPiece = locationPiece
        self.index = index
        self.number = number
    }
}
