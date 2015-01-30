//
//  StickHeaderView.swift
//  Persei
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

private var ContentOffsetContext = 0

public class StickHeaderView: UIView {
    
    // MARK: - View lifecycle
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        scrollView = nil
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            scrollView = superview as UIScrollView
        }
    }

    // MARK: - Background Image
    lazy private var backgroundImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        return imageView
    }()

    @IBInspectable
    public var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }

    // MARK: - ContentView
    public var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                
                self.addSubview(view)
                self.setNeedsLayout()
            }
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
                } else {
                    self.removeInsets()
                }
            }
        }
    }

    private func fractionRevealed() -> CGFloat {
        return CGRectGetHeight(bounds) / contentHeight
    }

    // MARK: - Applyied Insets
    private var appliedInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var insetsApplied: Bool {
        return appliedInsets != UIEdgeInsetsZero
    }

    private func applyInsets(insets: UIEdgeInsets, animated: Bool) {
        let originalInset = scrollView.contentInset - appliedInsets
        let targetInset = originalInset + insets

        self.appliedInsets = insets
        
        if animated {
            UIView.animateWithDuration(0.2) {
                self.scrollView.contentInset = targetInset
            }
        } else {
            scrollView.contentInset = targetInset
        }
    }
    
    private func addInsets(animated: Bool = true) {
        assert(!insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsets(top: contentHeight, left: 0.0, bottom: 0.0, right: 0.0), animated: animated)
    }

    private func removeInsets(animated: Bool = true) {
        assert(insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsetsZero, animated: animated)
    }
    
    // MARK: - BarHeight
    @IBInspectable
    public var contentHeight: CGFloat = 64.0 {
        didSet {
            layoutToFit()
        }
    }
    
    // MARK: - Threshold
    @IBInspectable
    public var threshold: CGFloat = 0.3
    
    // MARK: - Content Offset Hanlding
    private func didScroll() {
        layoutToFit()
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        let alpha = -acos(min(bounds.height, contentHeight) / contentHeight)
        transform = CATransform3DRotate(transform, alpha, 1.0, 0.0, 0.0)
        
        contentView?.layer.transform = transform
    }
    
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Ended {
            let value = scrollView.normalizedContentOffset.y
            let triggeringValue = CGRectGetHeight(bounds) * threshold
            let multiplier: CGFloat = revealed ? 1.0 : -1.0

            if triggeringValue < value * multiplier {
                revealed = !revealed
            }
        }
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        backgroundImageView.frame = bounds
        contentView?.frame = CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(bounds), height: contentHeight)
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
