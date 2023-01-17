//
//  ContentViewModel.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/14.
//

import CoreImage
import AppKit

class ContentViewModel: ObservableObject {
  @Published var frame: CGImage?
  private let frameManager = FrameManager.shared
  
  @Published var error: Error?
  private let cameraManager = CameraManager.shared
  
  var averageRed: Float = 0
  var sessionStarted: Bool = false
  private var takePhotoFlag: Bool = false
  
  private let context = CIContext()

  init() {
    setupSubscriptions()
  }
  
  func resetTakePhotoFlag(){
    self.takePhotoFlag = false
  }
  
  func setupSubscriptions() {
//    frameManager.$current
//      .receive(on: RunLoop.main)
//      .compactMap { buffer in
//        return CGImage.create(from: buffer)
//      }
//      .assign(to: &$frame)

    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { $0 }
      .compactMap { buffer in
        if self.takePhotoFlag == true {
          return nil
        }
        guard let image = CGImage.create(from: buffer) else {
          return nil
        }
        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        let nsimage = NSImage(cgImage: image, size: CGSize(width: width, height: height))
        let color = nsimage.averageColor
        let red = color?.redComponent ?? 0
        print("red: ", red)
        self.averageRed = Float(red)
        if self.cameraManager.session.isRunning == true && self.sessionStarted == false {
          self.sessionStarted = true
        }
        print(self.cameraManager.session.isRunning)
        let differenceInSeconds = Int(Date().timeIntervalSince(self.cameraManager.sessionStartDate ?? Date()))
        print(differenceInSeconds)
        
        // at least wait for 2 seconds
        if red > 0.4 && differenceInSeconds > 2 {
          print("2 second has passed.")
          self.takePhotoFlag = true
          self.cameraManager.makePhotoAndStopCamera()
          
        // maximum wait for 5 sec
        }else if differenceInSeconds > 5{
          self.takePhotoFlag = true
          print("5 second has passed.")
          self.cameraManager.makePhotoAndStopCamera()
        }

        return image
//        let ciImage = CIImage(cgImage: image)
//        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)
    
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)
  }
}
