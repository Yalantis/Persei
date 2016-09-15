// For License please refer to LICENSE file in the root of Persei project

import QuartzCore

class CircularRevealTransition: NSObject {
    
    var completion: (() -> Void)?

    fileprivate let layer: CALayer
    fileprivate let snapshotLayer: CALayer
    fileprivate let mask: CAShapeLayer
    fileprivate let animation: CABasicAnimation
    
    // MARK: - Init
    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        let startPath = CGPath(ellipseIn: CGRect(boundingCenter: center, radius: startRadius), transform: nil)
        let endPath = CGPath(ellipseIn: CGRect(boundingCenter: center, radius: endRadius), transform: nil)

        self.layer = layer
        snapshotLayer = CALayer()
        snapshotLayer.contents = layer.contents
    
        mask = CAShapeLayer()
        mask.path = endPath

        animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.6
        animation.fromValue = startPath
        animation.toValue = endPath
        
        super.init()
        animation.delegate = self
    }
    
    convenience init(layer: CALayer, center: CGPoint) {
        let radius: CGFloat = {
            let frame = layer.frame
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return hypot(x, y)
        }()
        
        self.init(layer: layer, center: center, startRadius: 0, endRadius: radius)
    }

    func start() {
        layer.superlayer!.insertSublayer(snapshotLayer, below: layer)
        snapshotLayer.frame = layer.frame
        
        layer.mask = mask
        mask.frame = layer.bounds

        mask.add(animation, forKey: "reveal")
    }
}

extension CircularRevealTransition: CAAnimationDelegate {
    
    func animationDidStop(_: CAAnimation, finished: Bool) {
        layer.mask = nil
        snapshotLayer.removeFromSuperlayer()
        
        completion?()
    }
}
