// For License please refer to LICENSE file in the root of Persei project

import UIKit

class HeaderShadowView: UIView {
    
    override class var layerClass: AnyClass {
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
    
    fileprivate func setupLayer() {
        if let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor(white: 0, alpha: 0.5).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        }
    }
}
