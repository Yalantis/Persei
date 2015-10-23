// For License please refer to LICENSE file in the root of Persei project

import QuartzCore

class CircularRevealTransition {
    var completion: () -> Void = {}

    private let layer: CALayer
    private let snapshotLayer: CALayer
    private let mask: CAShapeLayer
    private let animation: CABasicAnimation
    
    // MARK: - Init
    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        let startPath = CGPathCreateWithEllipseInRect(CGRect(boundingCenter: center, radius: startRadius), nil)
        let endPath = CGPathCreateWithEllipseInRect(CGRect(boundingCenter: center, radius: endRadius), nil)

        self.layer = layer
        snapshotLayer = CALayer()
        snapshotLayer.contents = layer.contents
    
        mask = CAShapeLayer()
        mask.path = endPath

        animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.6
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = self
    }
    
    convenience init(layer: CALayer, center: CGPoint) {
        let frame = layer.frame
        
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()
        
        self.init(layer: layer, center: center, startRadius: 0, endRadius: radius)
    }


    func start() {
        layer.superlayer!.insertSublayer(snapshotLayer, below: layer)
        snapshotLayer.frame = layer.frame
        
        layer.mask = mask
        mask.frame = layer.bounds

        mask.addAnimation(animation, forKey: "reveal")
    }
    
    // MARK: - CAAnimationDelegate
    @objc
    private func animationDidStop(_: CAAnimation, finished: Bool) {
        layer.mask = nil
        snapshotLayer.removeFromSuperlayer()
        
        completion()
    }
}