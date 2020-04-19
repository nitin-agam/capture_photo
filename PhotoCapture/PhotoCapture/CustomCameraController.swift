//
//  CustomCameraController.swift
//  PhotoCapture
//
//  Created by Nitin A on 19/04/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Variables
    lazy private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    private let photoOutput = AVCapturePhotoOutput()
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        
        view.addSubviews(backButton, takePhotoButton)
        
        takePhotoButton.makeConstraints(top: nil, left: nil, right: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 15, width: 80, height: 80)
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
    }
    
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // the user has already authorized to access the camera.
            self.setupCaptureSession()
            
        case .notDetermined: // the user has not yet asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // if user has granted to access the camera.
                    print("the user has granted to access the camera")
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    print("the user has not granted to access the camera")
                    self.handleDismiss()
                }
            }
            
        case .denied:
            print("the user has denied previously to access the camera.")
            self.handleDismiss()
            
        case .restricted:
            print("the user can't give camera access due to some restriction.")
            self.handleDismiss()
            
        default:
            print("something has wrong due to we can't access the camera.")
            self.handleDismiss()
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
            
            captureSession.startRunning()
            self.setupUI()
        }
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
        photoPreviewContainer.photoImageView.image = previewImage
        self.view.addSubviews(photoPreviewContainer)
    }
}
