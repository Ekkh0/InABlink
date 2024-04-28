/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import AVFoundation
import Vision
import SwiftUI

class FaceDetectionViewController: NSObject, ObservableObject{
  var sequenceHandler = VNSequenceRequestHandler()
    
  let session = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer!
  
  let dataOutputQueue = DispatchQueue(
    label: "video data queue",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem)

  var faceViewHidden = false
  
  var maxX: CGFloat = 0.0
  var midY: CGFloat = 0.0
  var maxY: CGFloat = 0.0
  
  @Published var didBlink: Bool = false
  @Published var blinkCounter: Int = 0

    override init(){
        super.init()
        dataOutputQueue.async(){[unowned self] in
            self.configureCaptureSession()
            self.session.startRunning()
        }
        
        maxX = UIScreen.main.bounds.maxX
        midY = UIScreen.main.bounds.midY
        maxY = UIScreen.main.bounds.maxY
    }
  
  func convert(rect: CGRect) -> CGRect {
    // 1
    let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
    
    // 2
    let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
    
    // 3
    return CGRect(origin: origin, size: size.cgSize)
  }
  
  // 1
  func landmark(point: CGPoint, to rect: CGRect) -> CGPoint {
    // 2
    let absolute = point.absolutePoint(in: rect)
    
    // 3
    let converted = previewLayer.layerPointConverted(fromCaptureDevicePoint: absolute)
    
    // 4
    return converted
  }
  
  func landmark(points: [CGPoint]?, to rect: CGRect) -> [CGPoint]? {
    return points?.compactMap { landmark(point: $0, to: rect) }
  }
  
  func polygonArea(points: Array<CGPoint>) -> Double {
    var area:Double = 0.0
    
    let a = abs(points[1].y-points[5].y)
    let b = abs(points[2].y-points[4].y)
    let c = abs(points[0].x-points[3].x)
    
    area = a+b/2*c

    return area
  }
  
  func updateFaceView(for result: VNFaceObservation) {
    guard let landmarks = result.landmarks else {
      return
    }
      
    if let leftEye = landmark(
      points: landmarks.leftEye?.normalizedPoints,
      to: result.boundingBox) {
//        print("\(leftEye)")
      
      if(polygonArea(points: leftEye)<180 && !didBlink){
        didBlink.toggle()
        blinkCounter+=1
        print("Blinked! Number of blink: \(blinkCounter)")
      }else if(polygonArea(points: leftEye)>180 && didBlink){
        didBlink.toggle()
        print("Out of Blink!")
      }
    }
  }
  
  func detectedFace(request: VNRequest, error: Error?) {
    // 1
    guard
      let results = request.results as? [VNFaceObservation],
      let result = results.first
      else {
        // 2
//        faceView.clear()
        return
    }
      
    updateFaceView(for: result)
  }
}

// MARK: - Video Processing methods

extension FaceDetectionViewController {
  func configureCaptureSession() {
    // Define the capture device we want to use
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                               for: .video,
                                               position: .front) else {
      fatalError("No front video camera available")
    }
    
    // Connect the camera to the capture session input
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      session.addInput(cameraInput)
    } catch {
      fatalError(error.localizedDescription)
    }
    
    // Create the video data output
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    
    // Add the video output to the capture session
    session.addOutput(videoOutput)
    
    let videoConnection = videoOutput.connection(with: .video)
    videoConnection?.videoOrientation = .portrait
    
    // Configure the preview layer
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
      previewLayer.frame = UIScreen.main.bounds
//    view.layer.insertSublayer(previewLayer, at: 0)
  }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods

extension FaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // 1
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }

    // 2
    let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)

    // 3
    do {
      try sequenceHandler.perform(
        [detectFaceRequest],
        on: imageBuffer,
        orientation: .leftMirrored)
    } catch {
      print(error.localizedDescription)
    }

  }
}
