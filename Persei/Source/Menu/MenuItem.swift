//
// Created by zen on 31/01/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit.UIImage

public struct MenuItem {
    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    public var highlightedBackgroundColor = UIColor(red: 1.0, green: 61.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    
    public var shadowColor = UIColor(white: 0.3, alpha: 0.3)
    
    // MARK: - Init
    public init(image: UIImage, highlightedImage: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlightedImage
    }    
}
