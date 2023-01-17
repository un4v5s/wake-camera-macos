//
//  wake_cameraApp.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/14.
//

import SwiftUI

@main
struct wake_cameraApp: App {
  @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
      MenuBarExtra(
          "App Menu Bar Extra", systemImage: "star",
          isInserted: $showMenuBarExtra)
      {
          MenuBarView()
      }

    }
}
