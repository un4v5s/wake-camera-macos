//
//  NSWorkspaceExtension.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/18.
//

import Foundation
import SwiftUI

extension NSWorkspace {
  static func onWakeup(_ fn: @escaping (Notification) -> Void) {
    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification,
                                                      object: nil,
                                                      queue: nil,
                                                      using: fn)
  }
  
  static func onSleep(_ fn: @escaping (Notification) -> Void) {
    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification,
                                                      object: nil,
                                                      queue: nil,
                                                      using: fn)
  }
}
