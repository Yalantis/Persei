// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit
import QuartzCore

private var ContentOffsetContext = 0

private let DefaultContentHeight: CGFloat = 64

public class StickyHeaderView: UIView {
    // MARK: - Init
    func commonInit() {
        addSubview(backgroundImageView)
        addSubview(contentContainer)

        contentContainer.addSubview(shadowView)
        
        clipsToBounds = true
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 320, height: DefaultContentHeight))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - View lifecycle
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview == nil, let view = superview as? UIScrollView {
            view.removeObserver(self, forKeyPath: "contentOffset", context: &ContentOffsetContext)
            view.panGestureRecognizer.removeTarget(self, action: "handlePan:")
            appliedInsets = UIEdgeInsetsZero
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let view = superview as? UIScrollView {
            view.addObserver(self, forKeyPath: "contentOffset", options: [.Initial, .New], context: &ContentOffsetContext)
            view.panGestureRecognizer.addTarget(self, action: "handlePan:")
            view.sendSubviewToBack(self)
        }
    }

    private let contentContainer: UIView = {
        let view = UIView()
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        view.backgroundColor = UIColor.clearColor()

        return view
    }()
    
    private let shadowView = HeaderShadowView(frame: CGRectZero)
    
    @IBOutlet
    public var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.frame = contentContainer.bounds
                view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                contentContainer.addSubview(view)
                contentContainer.sendSubviewToBack(view)
            }
        }
    }
    
    public enum ContentViewGravity {
        case Top, Center, Bottom
    }
    
    /**
    Affects on `contentView` sticking position during view stretching: 
    
    - Top: `contentView` sticked to the top position of the view
    - Center: `contentView` is aligned to the middle of the streched view
    - Bottom: `contentView` sticked to the bottom
    
    Default value is `Center`
    **/
    public var contentViewGravity: ContentViewGravity = .Center
    
    // MARK: - Background Image
    private let backgroundImageView = UIImageView()

    @IBInspectable
    public var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
            backgroundImageView.hidden = backgroundImage == nil
        }
    }
    
    // MARK: - ScrollView
    private var scrollView: UIScrollView! { return superview as! UIScrollView }
    
    // MARK: - KVO
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &ContentOffsetContext {
            didScroll()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - State
    public var revealed: Bool = false {
        didSet {
            if oldValue != revealed {
                if revealed {
                    self.addInsets()
                } else {
                    self.removeInsets()
                }
            }
        }
    }
    
    private func setRevealed(revealed: Bool, animated: Bool, adjustContentOffset adjust: Bool) {
        if animated {
            UIView.animateWithDuration(0.2, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {
                self.revealed = revealed
            }, completion: { completed in
                if adjust {
                    UIView.animateWithDuration(0.2) {
                        self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
                    }
                }
            })
        } else {
            self.revealed = revealed
            
            if adjust {
                self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
            }
        }
    }
    
    public func setRevealed(revealed: Bool, animated: Bool) {
        setRevealed(revealed, animated: animated, adjustContentOffset: true)
    }

    private func fractionRevealed() -> CGFloat {
        return min(bounds.height / contentHeight, 1)
    }

    // MARK: - Applyied Insets
    private var appliedInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var insetsApplied: Bool {
        return appliedInsets != UIEdgeInsetsZero
    }

    private func applyInsets(insets: UIEdgeInsets) {
        let originalInset = scrollView.contentInset - appliedInsets
        let targetInset = originalInset + insets

        appliedInsets = insets
        scrollView.contentInset = targetInset
    }
    
    private func addInsets() {
        assert(!insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsets(top: contentHeight, left: 0, bottom: 0, right: 0))
    }

    private func removeInsets() {
        assert(insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - ContentHeight
    @IBInspectable
    public var contentHeight: CGFloat = DefaultContentHeight {
        didSet {
            if superview != nil {
                layoutToFit()
            }
        }
    }
    
    // MARK: - Threshold
    @IBInspectable
    public var threshold: CGFloat = 0.3
    
    // MARK: - Content Offset Hanlding
    private func applyContentContainerTransform(progress: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        let angle = (1 - progress) * CGFloat(M_PI_2)
        transform = CATransform3DRotate(transform, angle, 1, 0, 0)
        
        contentContainer.layer.transform = transform
    }
    
    private func didScroll() {
        layoutToFit()
        layoutIfNeeded()
        
        let progress = fractionRevealed()
        shadowView.alpha = 1 - progress

        applyContentContainerTransform(progress)
    }
    
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Ended {
            let value = scrollView.normalizedContentOffset.y * (revealed ? 1 : -1)
            let triggeringValue = contentHeight * threshold
            let velocity = recognizer.velocityInView(scrollView).y
            
            if triggeringValue < value {
                let adjust = !revealed || velocity < 0 && -velocity < contentHeight
                setRevealed(!revealed, animated: true, adjustContentOffset: adjust)
            } else if 0 < bounds.height && bounds.height < contentHeight {
                UIView.animateWithDuration(0.3) {
                    self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
                }
            }
        }
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        backgroundImageView.frame = bounds
        
        let containerY: CGFloat
        switch contentViewGravity {
        case .Top:
            containerY = min(bounds.height - contentHeight, bounds.minY)

        case .Center:
            containerY = min(bounds.height - contentHeight, bounds.midY - contentHeight / 2)
            
        case .Bottom:
            containerY = bounds.height - contentHeight
        }
        
        contentContainer.frame = CGRect(x: 0, y: containerY, width: bounds.width, height: contentHeight)
        // shadow should be visible outside of bounds during rotation
        shadowView.frame = CGRectInset(contentContainer.bounds, -round(contentContainer.bounds.width / 16), 0)
    }

    private func layoutToFit() {
        let origin = scrollView.contentOffset.y + scrollView.contentInset.top - appliedInsets.top
        frame.origin.y = origin
        
        sizeToFit()
    }
    
    public override func sizeThatFits(_: CGSize) -> CGSize {
        var height: CGFloat = 0
        if revealed {
            height = appliedInsets.top - scrollView.normalizedContentOffset.y
        } else {
            height = scrollView.normalizedContentOffset.y * -1
        }

        let output = CGSize(width: CGRectGetWidth(scrollView.bounds), height: max(height, 0))
        
        return output
    }
}
