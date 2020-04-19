//
//  PhotoPreviewView.swift
//  PhotoCapture
//
//  Created by Nitin A on 19/04/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import Photos

class PhotoPreviewView: UIView {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(photoImageView, cancelButton, savePhotoButton)
        
        photoImageView.makeConstraints(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 0, width: 0, height: 0)
        
        cancelButton.makeConstraints(top: safeAreaLayoutGuide.topAnchor, left: nil, right: rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
        
        savePhotoButton.makeConstraints(top: nil, left: nil, right: cancelButton.leftAnchor, bottom: nil, topMargin: 0, leftMargin: 0, rightMargin: 5, bottomMargin: 0, width: 50, height: 50)
        savePhotoButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleCancel() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @objc private func handleSavePhoto() {
        
        guard let previewImage = self.photoImageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("photo has saved in library...")
                        self.handleCancel()
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}
