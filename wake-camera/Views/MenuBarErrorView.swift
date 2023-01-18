//
//  MenuBarErrorView.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/19.
//

import SwiftUI

struct MenuBarErrorView: View {
  var error: Error?
  
  var body: some View {
    Text("⚠️Error: " + error!.localizedDescription)    
  }
}

struct MenuBarErrorView_Previews: PreviewProvider {
  static var previews: some View {
    MenuBarErrorView(error: CameraError.cannotAddInput)
  }
}
