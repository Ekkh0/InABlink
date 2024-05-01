////
////  AnswerTile.swift
////  MathGame
////
////  Created by Putri Wulandari Oktaviani on 27/04/24.
////
//
//import SwiftUI
//
//struct AnswerTile1: View {
//    @Binding var tile: Tile
//    
//    @ViewBuilder
//    var body: some View {
//        VStack{        
//            Text("\(tile.number)")
//                .fontWeight(.bold)
//                .foregroundStyle(Color.white)
//                .frame(width: 80,height: 80)
//                .background(Color.blue)
//                .cornerRadius(/*@START_MENU_TOKEN@*/24.0/*@END_MENU_TOKEN@*/)
//                .font(.system(size: 40))
//                .position(x: tile.locationPiece.x,y: tile.locationPiece.y)
//                .gesture(
//                    DragGesture()
//                        .onChanged({ value in
//                            tile.locationPiece.x = value.location.x
//                            tile.locationPiece.y = value.location.y
//                        })
//                )
//        }
//    }
//}
