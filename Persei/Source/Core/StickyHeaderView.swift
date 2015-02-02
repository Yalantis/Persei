//
//  StickyHeaderView.swift
//  Persei
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

private var ContentOffsetContext = 0

private let DefaultContentHeight: CGFloat = 64.0

public class StickyHeaderView: UIView {
    // MARK: - Init
    func commonInit() {
        addSubview(backgroundImageView)
        addSubview(contentContainer)

        contentContainer.layer.addSublayer(shadowLayer)
        
        clipsToBounds = true
    }

    public override init(frame: CGRect = CGRect(x: 0.0, y: 0.0, width: 320.0, height: DefaultContentHeight)) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - View lifecycle
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        scrollView = nil
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            scrollView = superview as UIScrollView
            scrollView.sendSubviewToBack(self)
        }
    }

    private let contentContainer: UIView = {
        let view = UIView()
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        view.backgroundColor = UIColor.clearColor()

        return view
    }()
    
    private let shadowLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(white: 0.0, alpha: 0.5).CGColor, UIColor.clearColor()]
        layer.startPoint = CGPoint(x: 0.5, y: 1.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
        return layer
    }()
    
    @IBOutlet
    public var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.frame = contentContainer.bounds
                view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                contentContainer.addSubview(view)
                contentContainer.sendSubviewToBack(view)
            }
        }
    }
    
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
    private weak var scrollView: UIScrollView! {
        willSet {
            self.scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &ContentOffsetContext)
            self.scrollView?.panGestureRecognizer.removeTarget(self, action: "handlePan:")
            
            appliedInsets = UIEdgeInsetsZero
        }
        
        didSet {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .Initial | .New, context: &ContentOffsetContext)
            scrollView?.panGestureRecognizer.addTarget(self, action: "handlePan:")
        }
    }
    
    // MARK: - KVO
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &ContentOffsetContext {
            didScroll()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - State
    public private(set) var revealed: Bool = false {
        didSet {
            if oldValue != revealed {
                if revealed {
                    self.addInsets()
                    
                    // if insets relatively large then scroll view doens't reveal the menu completely, so we need to "help"
                    let adjustedOffset = CGPoint(x: frame.origin.x, y: frame.origin.y - appliedInsets.top)
                    scrollView.contentOffset = adjustedOffset
                } else {
                    self.removeInsets()
                }
            }
        }
    }

    private func fractionRevealed() -> CGFloat {
        return min(CGRectGetHeight(bounds) / contentHeight, 1.0)
    }

    public func reveal() {
        revealed = true
    }

    public func close() {
        revealed = false
    }

    // MARK: - Applyied Insets
    private var appliedInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var insetsApplied: Bool {
        return appliedInsets != UIEdgeInsetsZero
    }

    private func applyInsets(insets: UIEdgeInsets) {
        let originalInset = scrollView.contentInset - appliedInsets
        let targetInset = originalInset + insets

        self.appliedInsets = insets
        self.scrollView.contentInset = targetInset
    }
    
    private func addInsets() {
        assert(!insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsets(top: contentHeight, left: 0.0, bottom: 0.0, right: 0.0))
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
    public var threshold: CGFloat = 0.2
    
    // MARK: - Content Offset Hanlding
    private func didScroll() {
        layoutToFit()
        layoutIfNeeded()
        
        CATransaction.setDisableActions(true)
        shadowLayer.opacity = 1.0 - Float(fractionRevealed())
        CATransaction.setDisableActions(false)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        let angle = (1.0 - fractionRevealed()) * 90.0 * CGFloat(M_PI) / 180.0
        transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        
        contentContainer.layer.transform = transform
    }
    
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Ended {
            let value = scrollView.normalizedContentOffset.y * (revealed ? 1.0 : -1.0)
            let triggeringValue = contentHeight * threshold
            
            if triggeringValue < value {
                UIView.animateWithDuration(0.2) {
                    self.revealed = !self.revealed
                }
            }
        }
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        backgroundImageView.frame = bounds
        contentContainer.frame = CGRect(
            x: 0.0,
            y: min(CGRectGetHeight(bounds) - contentHeight, CGRectGetMidY(bounds) - contentHeight / 2.0),
            width: CGRectGetWidth(bounds),
            height: contentHeight
        )
        shadowLayer.frame = contentContainer.bounds
    }

    private func layoutToFit() {
        var origin = scrollView.contentOffset.y + scrollView.contentInset.top - appliedInsets.top
        frame.origin.y = origin
        
        sizeToFit()
    }
    
    public override func sizeThatFits(_: CGSize) -> CGSize {
        var height: CGFloat = 0.0
        if revealed {
            height = appliedInsets.top - scrollView.normalizedContentOffset.y
        } else {
            height = scrollView.normalizedContentOffset.y * -1.0
        }

        let output = CGSize(width: CGRectGetWidth(scrollView.bounds), height: max(height, 0.0))
        
        return output
    }
}
