// For License please refer to LICENSE file in the root of Persei project

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
