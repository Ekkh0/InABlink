//
//  ContentView.swift
//  GestureTest
//
//  Created by Dharmawan Ruslan on 25/04/24.
//

import SwiftUI

struct LandingView: View {
//    @StateObject public var blinkDetection = FaceDetectionViewController()
    
    var body: some View {
        VStack {
            Image(systemName: "eye")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            NavigationLink {
                
            } label: {
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
        .padding([.top, .bottom], 100)
        .padding()
    }
}

#Preview {
    LandingView()
}
