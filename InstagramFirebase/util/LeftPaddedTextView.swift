//
//  LeftPaddedTextView.swift
//  InstagramFirebase
//
//  Created by Ilham Hadi Prabawa on 6/28/19.
//  Copyright © 2019 Codenesia. All rights reserved.
//

import Foundation
import UIKit

class LeftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}
