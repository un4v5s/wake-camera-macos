//
//  ControlView.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/19.
//

import SwiftUI

struct ControlView: View {
  @StateObject private var model = ContentViewModel()
  
  @Binding var averageRed: Float
  @Binding var sessionStarted: Bool
  private let cameraManager = CameraManager.shared
  
  @State var showFileChooser = false
  @State var folderPath = "Filename"
  @AppStorage("SaveFolderPath") private var saveFolderPath = NSHomeDirectory()
  
  var body: some View {
    VStack {
      Spacer()
      Text("SaveFolderPath: " + self.saveFolderPath)
      
      HStack(spacing: 12) {
        Text("Avg.: " + self.averageRed.description)
        Text("Session Started: " + self.sessionStarted.description)
//        Button("Open Save Folder"){
//          NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.saveFolderPath)
//        }
//        Button("Reset Folder"){
//          self.saveFolderPath = NSHomeDirectory()
//        }
//        Button("Choose Folder to Save")
//        {
//          let panel = NSOpenPanel()
//          panel.canChooseFiles = false
//          panel.canChooseDirectories = true
//          panel.allowsMultipleSelection = false
//          panel.canCreateDirectories = true
//          panel.directoryURL = URL(string: self.saveFolderPath)
//          if panel.runModal() == .OK {
//            self.saveFolderPath = panel.url?.path() ?? NSHomeDirectory()
//          }
//        }
        Button("wake", action: {
          self.cameraManager.start()
          self.model.resetTakePhotoFlag()
        })
        //          Button("stop", action: {self.cameraManager.stop()})
      }
    }
    
    
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
        .edgesIgnoringSafeArea(.all)
      
      ControlView(
        averageRed: .constant(0.1),
        sessionStarted: .constant(false)
      )
    }
  }
}
