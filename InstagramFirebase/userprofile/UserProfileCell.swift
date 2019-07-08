//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 4/2/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            guard let photoUrl = post?.imageUrl else { return }
            photoImageView.loadingImage(with: photoUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}


