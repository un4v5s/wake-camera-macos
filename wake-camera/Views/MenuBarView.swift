//
//  MenuBarView.swift
//  wake-camera
//
//  Created by un4v5s on 2023/01/18.
//

import SwiftUI
import LaunchAtLogin

// global var
let desktopPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").path()

struct MenuBarView: View {
  @AppStorage("SaveFolderPath") private var saveFolderPath = desktopPath
  
  @StateObject private var model = ContentViewModel()
  private let cameraManager = CameraManager.shared
  private let appHandlers = AppHandlers.shared
  
  @State private var showingAlert = false
  @State private var isConfirming = false
  
  @State private var showingConfirmation = false
  @State private var backgroundColor = Color.white
  @State private var showAlert = false
  
  var body: some View {
    Text("Save Folder: " + saveFolderPath)
    
    Button("Open Folder"){
      NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.saveFolderPath)
    }
    
    Button("Change Save Folder")
    {
      let panel = NSOpenPanel()
      panel.canChooseFiles = false
      panel.canChooseDirectories = true
      panel.allowsMultipleSelection = false
      panel.canCreateDirectories = true
      panel.directoryURL = URL(string: self.saveFolderPath)
      NSApplication.shared.activate(ignoringOtherApps: true)
      if panel.runModal() == .OK {
        self.saveFolderPath = panel.url?.path() ?? desktopPath
      }
    }
    
    Menu("More Settings") {
      Button("Reset Save Folder: " + desktopPath, role: .cancel){
        self.saveFolderPath = desktopPath
      }
      LaunchAtLogin.Toggle("Launch at login")
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
