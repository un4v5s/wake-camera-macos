//
//  NSImageExtension.swift
//  wake-camera
//
//  Created by un4v5s on 2023/01/14.
//

import SwiftUI

extension NSImage {
  static func create(from cgImage: CGImage, cvPixelBuffer: CVPixelBuffer) -> NSImage? {
    let width = CVPixelBufferGetWidth(cvPixelBuffer)
    let height = CVPixelBufferGetHeight(cvPixelBuffer)
    return NSImage(cgImage: cgImage, size: CGSize(width: width, height: height))
  }
  
  // Returns the average color that is present in the image.
  var averageColor: NSColor? {
    // Image is not valid, so we cannot get the average color
    if !isValid {
      return nil
    }
    
    // Create a CGImage from the NSImage
    var imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    let cgImageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
    
    // Create vector and apply filter
    let inputImage = CIImage(cgImage: cgImageRef!)
    let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
    
    let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector])
    let outputImage = filter!.outputImage!
    
    var bitmap = [UInt8](repeating: 0, count: 4)
    let context = CIContext(options: [.workingColorSpace: kCFNull!])
    context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
    
    return NSColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
  }
}
