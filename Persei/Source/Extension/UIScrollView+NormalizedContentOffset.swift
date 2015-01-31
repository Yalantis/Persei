//
//  UIScrollView+NormalizedContentOffset.swift
//  Persei
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

extension UIScrollView {
    var normalizedContentOffset: CGPoint {
        get {
            let contentOffset = self.contentOffset
            let contentInset = self.contentInset
            
            let output = CGPoint(x: contentOffset.x + contentInset.left, y: contentOffset.y + contentInset.top)
            return output
        }
        set {
            let contentInset = self.contentInset
            self.contentOffset = CGPoint(x: newValue.x - contentInset.left, y: newValue.y - contentInset.top)
        }
    }
}