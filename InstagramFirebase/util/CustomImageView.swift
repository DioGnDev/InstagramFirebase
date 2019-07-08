//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 4/3/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadingImage(with urlString: String) {
    
        self.image = nil
        lastURLUsedToLoadImage = urlString
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch profile image", error)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
    
}
