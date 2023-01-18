//
//  MenuBarView.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/18.
//

import SwiftUI

struct MenuBarView: View {
  @AppStorage("SaveFolderPath") private var saveFolderPath = NSHomeDirectory()
  
  @StateObject private var model = ContentViewModel()
  private let cameraManager = CameraManager.shared
  private let appHandlers = AppHandlers.shared

  
  var body: some View {
    Text("Save to: " + saveFolderPath)
    Button("Open Folder"){
      NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.saveFolderPath)
    }
    Button("Reset Folder"){
      self.saveFolderPath = NSHomeDirectory()
    }
    Button("Change Save Folder")
    {
      let panel = NSOpenPanel()
      panel.canChooseFiles = false
      panel.canChooseDirectories = true
      panel.allowsMultipleSelection = false
      panel.canCreateDirectories = true
      panel.directoryURL = URL(string: self.saveFolderPath)
      if panel.runModal() == .OK {
        self.saveFolderPath = panel.url?.path() ?? NSHomeDirectory()
      }
    }
    Divider()
    Button("Quit"){
      NSApplication.shared.terminate(nil)
    }
  }
}

struct MenuBarView_Previews: PreviewProvider {
  static var previews: some View {
    MenuBarView()
  }
}
