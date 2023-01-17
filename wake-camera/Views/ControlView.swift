/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
