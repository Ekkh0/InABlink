import UIKit
import ARKit
import Combine
import Foundation
import SwiftUI

class ARSessionManager: NSObject, ARSessionDelegate {
    var session: ARSession
    @ObservedObject var blinkDetection: BlinkDetection
    
    init(blinkDetection: BlinkDetection) {
        self.session = ARSession()
        self.blinkDetection = blinkDetection
        super.init()
        
        // Set ARSession's delegate to this manager
        self.session.delegate = self
        
        // Start AR face tracking configuration
        startFaceTracking()
    }
    
    // Start the AR session for face tracking
    func startFaceTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration)
    }
    
    // ARSessionDelegate method: Called when ARFrame is updated
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let faceAnchor = anchor as? ARFaceAnchor else { continue }
            // Update blink detection model
            blinkDetection.update(with: faceAnchor)
        }
    }
    
    // Pause the AR session when no longer needed
    func pause() {
        session.pause()
    }
}

class BlinkDetection: ObservableObject {
    @Published var didBlink: Bool = false
    private var blinkThreshold: Float = 0.5
    
    // Function to update based on ARFaceAnchor data
    func update(with faceAnchor: ARFaceAnchor) {
        let blendShapes = faceAnchor.blendShapes
        let leftBlink = blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
        let rightBlink = blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
        
        // Update the isBlinking state based on threshold
        didBlink = leftBlink > blinkThreshold && rightBlink > blinkThreshold
    }
}

