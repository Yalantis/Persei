//
//  BarView.swift
//  Persei
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit

private var ContentOffsetContext = 0

public class BarView: UIView {
    
    // MARK: - Init
    public override init(frame: CGRect = CGRect(x: 0.0, y: -64.0, width: 320.0, height: 64.0)) {
        super.init(frame: frame)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        }
    }
    
    // MARK: - KVO
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &ContentOffsetContext {
            didScroll(scrollView.contentOffset)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
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
    
    // MARK: - State
    enum State {
        case Default, Revealed
    }
    
    var state: State = .Default {
        didSet {
            if oldValue != state {
                switch state {
                case .Default:
                    self.addInsets()
                    
                case .Revealed:
                    self.removeInsets()
                }
            }
        }
    }
    
    // MARK: - Applyied Insets
    private var appliedInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var applyingInsets = false
    private var insetsApplied: Bool {
        return !applyingInsets && appliedInsets != UIEdgeInsetsZero
    }

    private func applyInsets(insets: UIEdgeInsets, animated: Bool) {
        appliedInsets = insets
        
        if animated {
            applyingInsets = true
            
            let curve : UIViewAnimationOptions = scrollView.dragging ? .CurveEaseOut : .CurveEaseInOut
            let options: UIViewAnimationOptions = .BeginFromCurrentState
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: .BeginFromCurrentState | curve, animations: {
                self.scrollView.contentInset = self.appliedInsets
            }, completion: { completed in
                self.applyingInsets = false
            })
        } else {
            scrollView.contentInset = appliedInsets
        }
    }
    
    private func addInsets(animated: Bool = true) {
        assert(!insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0), animated: animated)
    }

    private func removeInsets(animated: Bool = true) {
        assert(insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsetsZero, animated: animated)
    }
    
    // MARK: - Content Offset Hanlding
    private func didScroll(var offset: CGPoint) {
        offset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + appliedInsets.top)
        println(offset)
        
        frame = CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(scrollView.bounds), height: -64.0)
    }
    
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        if applyingInsets {
            return
        }
        
        switch recognizer.state {
        case .Ended:
            
            
            let insetsApplied = appliedInsets != UIEdgeInsetsZero
            let offset = scrollView.contentOffset
            
            if offset.y < 0.0 && !insetsApplied && scrollView.panGestureRecognizer.state != .Changed {
                addInsets()
            } else if insetsApplied {
                removeInsets()
            }
            
        default:
            break
        }
    }
}
