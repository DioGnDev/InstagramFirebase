//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 4/2/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet{
            self.photoImageView.image = selectedImage
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "updatefeed")
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextView()
    }
    
    fileprivate func setupImageAndTextView(){
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(photoImageView)
        photoImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: containerView.topAnchor, left: photoImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        
    }
    
    @objc fileprivate func handleShare(){
        
        guard let caption = captionTextView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload file \(err.localizedDescription)")
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let err = error {
                    print("Failed to load image \(err)")
                }
                guard let postImageURL = url?.absoluteString else { return }
                self.saveDataToFirebaseDatabase(with: postImageURL)
            })
        }
    }
    
    fileprivate func saveDataToFirebaseDatabase(with imageUrl: String){
        
        guard let postImage = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["imageUrl" : imageUrl,
                      "creationDate" : Date().timeIntervalSince1970,
                      "imageWidth" : postImage.size.width,
                      "imageHeight" : postImage.size.height,
                      "caption": caption] as [String : Any]
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save data \(err)")
            }
            
            self.dismiss(animated: true, completion: nil )
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
        
    }
    
}
