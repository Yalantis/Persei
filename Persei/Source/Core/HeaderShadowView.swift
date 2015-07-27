// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit
import QuartzCore

class HeaderShadowView: UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayer()
    }
    
    private func setupLayer() {
        if let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor(white: 0, alpha: 0.5).CGColor, UIColor.clearColor()]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        }
    }
}
