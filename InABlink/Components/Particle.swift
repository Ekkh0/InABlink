import SwiftUI

struct EffectView: View {
    
    @Binding var correct: Bool
    var symbolShown: String {
        correct ? "checkmark" : "xmark"
    }
    @State private var location = CGPoint.zero      // < here !!
    @State var showingParticle = false
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Rectangle()
                    .opacity(0)
                    .contentShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.height * 1.4, height: UIScreen.main.bounds.height)
                    .gesture(DragGesture(minimumDistance: 0).onEnded { value in
                        self.location = value.location // < here !!
                        self.showParticle()
                    })
                if self.showingParticle {
                    Image(systemName: symbolShown)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .position(self.location)    // < here !!
                }
            }
            .onAppear(){
                print("Terjalan!")
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func showParticle() {
        self.showingParticle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.showingParticle = false
        }
    }
    
}
