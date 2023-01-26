//
//  ContentView.swift
//  wake-camera
//
//  Created by un4v5s on 2023/01/19.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var model = ContentViewModel.shared
  private let cameraManager = CameraManager.shared
  private let appHandlers = AppHandlers.shared
  
  var body: some View {
    ZStack {
      FrameView(image: model.frame)
        .edgesIgnoringSafeArea(.all)
      
      ErrorView(error: model.error)
      
      ControlView(
        averageRed: $model.averageRed,
        sessionStarted: $model.sessionStarted
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
