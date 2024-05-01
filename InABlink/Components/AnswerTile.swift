//
//  AnswerTile.swift
//  InABlink
//
//  Created by Putri Wulandari Oktaviani on 01/05/24.
//

import SwiftUI

struct AnswerTile: View {
    var number : Int
    var body: some View {
        Text("\(number)")
            .fontWeight(.bold)
            .foregroundStyle(Color.white)
            .frame(width: 80,height: 80)
            
            
            .font(.system(size: 40))
    }
}

#Preview {
    AnswerTile(number: 100)
}
