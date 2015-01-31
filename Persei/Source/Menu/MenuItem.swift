//
// Created by zen on 31/01/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit.UIImage

public struct MenuItem {
    public var name: String?

    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    public var highlightedBackgroundColor = UIColor(red: 1.0, green: 61.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    
    public var shadowColor = UIColor(red: 41.0 / 255.0, green: 44.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
}
