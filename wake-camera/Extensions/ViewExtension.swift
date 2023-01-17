//
//  ViewExtension.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/16.
//

import SwiftUI

extension View {
  //    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
  //        self.modifier(ViewDidLoadModifier(action: action))
  //    }

  func onNotification(
    _ notificationName: Notification.Name,
    perform action: @escaping () -> Void
  ) -> some View {
    onReceive(NSWorkspace.shared.notificationCenter.publisher(
      for: notificationName
    )) { _ in
      action()
    }
  }

  func onDidWakeNotification(
    perform action: @escaping () -> Void
  ) -> some View {
    onNotification(
      NSWorkspace.didWakeNotification,
      perform: action
    )
  }

  func onWillSleepNotification(
    perform action: @escaping () -> Void
  ) -> some View {
    onNotification(
      NSWorkspace.willSleepNotification,
      perform: action
    )
  }
}
