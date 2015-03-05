//
// Created by zen on 05/03/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    init(boundingCenter center: CGPoint, radius: CGFloat) {
        assert(0 <= radius, "radius must be a positive value")
        
        self = CGRectInset(CGRect(origin: center, size: CGSizeZero), -radius, -radius)
    }
}