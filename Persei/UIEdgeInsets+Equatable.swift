//
//  UIEdgeInsets+Operators.swift
//  Persei
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

extension UIEdgeInsets: Equatable {
}

public func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
    return UIEdgeInsetsEqualToEdgeInsets(lhs, rhs)
}

func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    var l: Int
    
    return UIEdgeInsets(
        top: lhs.top + rhs.top,
        left: lhs.left + rhs.left,
        bottom: lhs.bottom + rhs.bottom,
        right: lhs.right + rhs.right
    )
}

func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(
        top: lhs.top - rhs.top,
        left: lhs.left - rhs.left,
        bottom: lhs.bottom - rhs.bottom,
        right: lhs.right - rhs.right
    )
}
