//
//  CameraManager.swift
//  wake-camera
//
//  Created by un4v5s on 2023/01/14.
//

import AVFoundation

class CameraManager: ObservableObject {
  enum Status {
    case unconfigured
    case configured
    case unauthorized
    case failed
  }
  
  static let shared = CameraManager()
  
  @Published var error: CameraError?
  
  let session = AVCaptureSession()
  
  private let sessionQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
  private let videoOutput = AVCaptureVideoDataOutput()
  private var status = Status.unconfigured
  
  @Published var sessionStartDate: Date?
  private var cameraCaptureOutput: CameraCaptureOutput?
  private var photoOutput = AVCapturePhotoOutput()
    
  private init() {
    print("init CameraManager")
    configure()
  }
  
  private func set(error: CameraError?) {
    DispatchQueue.main.async {
      self.error = error
    }
  }
  
  private func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video) { authorized in
        if !authorized {
          self.status = .unauthorized
          self.set(error: .deniedAuthorization)
        }
        self.sessionQueue.resume()
      }
    case .restricted:
      status = .unauthorized
      set(error: .restrictedAuthorization)
    case .denied:
      status = .unauthorized
      set(error: .deniedAuthorization)
    case .authorized:
      break
    @unknown default:
      status = .unauthorized
      set(error: .unknownAuthorization)
    }
  }
  
  private func configureCaptureSession() {
    guard status == .unconfigured else {
      return
    }
    session.beginConfiguration()
    defer {
      session.commitConfiguration()
    }
    
    let device = AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: .video,
      position: .front)
    guard let camera = device else {
      set(error: .cameraUnavailable)
      status = .failed
      return
    }
    
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      
      if session.canAddInput(cameraInput) {
        session.addInput(cameraInput)
      } else {
        set(error: .cannotAddInput)
        status = .failed
        return
      }
    } catch {
      set(error: .createCaptureInput(error))
      status = .failed
      return
    }
    
    if session.canAddOutput(videoOutput) {
      session.addOutput(videoOutput)
      
      videoOutput.videoSettings =
      [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
      
      let videoConnection = videoOutput.connection(with: .video)
      videoConnection?.videoOrientation = .portrait
    } else {
      set(error: .cannotAddOutput)
      status = .failed
      return
    }
    
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
      
    } else {
      set(error: .cannotAddOutput)
      status = .failed
      return
    }
    
    status = .configured
  }
  
  private func configure() {
    checkPermissions()
    sessionQueue.async {
      self.configureCaptureSession()
    }
  }
  
  func set(
    _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
    queue: DispatchQueue
  ) {
    sessionQueue.async {
      self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
    }
  }
  
  func start(){
    sessionQueue.async {
      self.sessionStartDate = Date()
      self.session.startRunning()
    }
  }
  
  func stop(){
    sessionQueue.async {
      self.sessionStartDate = nil
      self.session.stopRunning()
    }
  }
  
  func makePhotoAndStopCamera() {
    print("makePhoto()")
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    let CameraCaptureOutput = CameraCaptureOutput()
    self.photoOutput.capturePhoto(with: settings, delegate: CameraCaptureOutput)
    self.cameraCaptureOutput = CameraCaptureOutput
  }
}

