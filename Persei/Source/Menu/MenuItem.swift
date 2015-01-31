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
    
    public var backgroundColor = UIColor.blackColor()
    public var highlightedBackgroundColor = UIColor.redColor()
}
