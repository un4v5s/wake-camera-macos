//
//  CameraCaptureOutput.swift
//  wake-camera
//
//  Created by Reona Ogino on 2023/01/16.
//

import AVFoundation
import AppKit

class CameraCaptureOutput: NSObject, AVCapturePhotoCaptureDelegate {
  private let cameraManager = CameraManager.shared

  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) -> Void {
    print("didFinishProcessingPhoto - \(photo)")
    
    defer {
      // stop camera after save
      cameraManager.stop()
    }

    guard let imageData = photo.fileDataRepresentation()
    else { return }

    let image = NSImage(data: imageData)

    let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)

    let folderPath = URL(fileURLWithPath: "wake-images/", isDirectory: true, relativeTo: paths[0])
    let exists = directoryExistsAtPath(folderPath.path)
    if exists {
      print("yes")
    }else{
      print("no")
      do {
        try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true)
      } catch{
        fatalError("Failed to create directory: \(error.localizedDescription)")
      }
    }
    
    let newImagePathPNG = URL(fileURLWithPath: String(NSDate().timeIntervalSince1970 * 1000) + ".png"  , isDirectory: false, relativeTo: folderPath)
    let result = self.savePNG(image: image!, path: newImagePathPNG)
    print("capture photo, result=\(result)")
    
    let newImagePathJPEG = URL(fileURLWithPath: String(NSDate().timeIntervalSince1970 * 1000) + ".jpeg"  , isDirectory: false, relativeTo: folderPath)
    let result2 = self.saveJPEG(image: image!, path: newImagePathJPEG)
    print("capture photo, result=\(result2)")
    
    
    return
  }
  
//  func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//    print("didCapturePhotoFor - \(resolvedSettings)")
////    cameraManager.stop()
//  }

  func savePNG(image: NSImage, path: URL) -> Bool {
    let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
    let pngData = imageRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
    
    do {
      try pngData?.write(to: path, options: [.atomic])
    } catch {
      fatalError("Failed to write: \(error.localizedDescription)")
    }
    
    return true
  }
  
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
  
  fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
      var isDirectory = ObjCBool(true)
      let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
      return exists && isDirectory.boolValue
  }
}

