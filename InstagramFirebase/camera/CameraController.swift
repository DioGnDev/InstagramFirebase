//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 4/23/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleCapturePhoto(){
        print("capturing photo")
    }
    
    @objc fileprivate func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupHUD()
    }
    
    fileprivate func setupHUD(){
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
        //setup inputs
        let captureDevice = AVCaptureDevice.default(for: .video)
        guard let captureDev = captureDevice else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDev)
            captureSession.addInput(input)
        }catch let err {
            print("Could not setup camera input", err)
        }
        
        //setup outputs
        let output = AVCapturePhotoOutput()
        captureSession.addOutput(output)
        
        //setup preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    
}
