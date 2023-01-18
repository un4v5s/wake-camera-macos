//
//  AppHandlers.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/18.
//

import SwiftUI

class AppHandlers: ObservableObject {
  static let shared = AppHandlers()

  private let model = ContentViewModel.shared
  private let cameraManager = CameraManager.shared
  
  private init() {
    configure()
    print("init AppHandlers")
    
  }
  
  private func configure(){
    NSWorkspace.onWakeup { _ in
      print("onWakeup")
      self.cameraManager.start()
      self.model.resetTakePhotoFlag()
    }
    
    NSWorkspace.onSleep { _ in
      print("onSleep")
      self.cameraManager.stop()
    }
  }
}
