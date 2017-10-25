// For License please refer to LICENSE file in the root of Persei project

import UIKit

extension UIScrollView {
    
    /// Content offset that incorporates content offset to align default value to (0, 0) instead of a adjusted one.
    var normalizedContentOffset: CGPoint {
        get {
            let contentOffset = self.contentOffset
            let contentInset = self.effectiveContentInset
            
            let output = CGPoint(x: contentOffset.x + contentInset.left, y: contentOffset.y + contentInset.top)
            return output
        }
    }
    
    /// Effective content inset used by a scroll view for both iOS 10 / 11. iOS 11 introduced new `contentInsetAdjustmentBehavior` that may
    /// include a new `UIView.safeAreaInsets` or not depending on the mode. `effectiveContentInsets` makes hides this details, so you may think of using
    /// `UIScrollView.contentInset` iOS 10-like behaviour.
    var effectiveContentInset: UIEdgeInsets {
        get {
            if #available(iOS 11, *) {
                return adjustedContentInset
            } else {
                return contentInset
            }
        }
        
        set {
            if #available(iOS 11.0, *), contentInsetAdjustmentBehavior != .never {
                contentInset = newValue - safeAreaInsets
            } else {
                contentInset = newValue
            }
        }
    }
}
