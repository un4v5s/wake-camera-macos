//
//  CameraCaptureOutput.swift
//  wake-camera
//
//  Created by un4v5s on 2023/01/16.
//

import AVFoundation
import AppKit
import SwiftUI

class CameraCaptureOutput: NSObject, AVCapturePhotoCaptureDelegate {
  private let cameraManager = CameraManager.shared
  @AppStorage("SaveFolderPath") private var saveFolderPath = NSHomeDirectory()
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) -> Void {
    print("didFinishProcessingPhoto - \(photo)")
    
    defer {
      // stop camera after save
      cameraManager.stop()
    }
    
    guard let imageData = photo.fileDataRepresentation() else { return }
    
    let image = NSImage(data: imageData)
    
    let folderPath = URL(string: "file://\(self.saveFolderPath)")
    
    // PNG
    //    let newImagePathPNG = URL(fileURLWithPath: String(NSDate().timeIntervalSince1970 * 1000) + ".png"  , isDirectory: false, relativeTo: folderPath)
    //    let resultPng = self.savePNG(image: image!, path: newImagePathPNG)
    //    print("capture photo, result=\(resultPng)")
    
    let newImagePathJPEG = URL(fileURLWithPath: String(NSDate().timeIntervalSince1970 * 1000) + ".jpeg"  , isDirectory: false, relativeTo: folderPath)
    let resultJpeg = self.saveJPEG(image: image!, path: newImagePathJPEG)
    print("capture photo, result=\(resultJpeg)")
    
    return
  }

//  func savePNG(image: NSImage, path: URL) -> Bool {
//    let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
//    let pngData = imageRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
//
//    do {
//      try pngData?.write(to: path, options: [.atomic])
//    } catch {
//      fatalError("Failed to write: \(error.localizedDescription)")
//    }
//
//    return true
//  }
  
  func saveJPEG(image: NSImage, path: URL) -> Bool {
    let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
    let jpegData = imageRep?.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [.compressionFactor:0.8])
    
    do {
      try jpegData?.write(to: path, options: [.atomic])
    } catch {
      fatalError("Failed to write: \(error.localizedDescription)")
    }
    
    return true
  }
}

