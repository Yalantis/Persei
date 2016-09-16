// For License please refer to LICENSE file in the root of Persei project

import UIKit

private var ContentOffsetContext = 0
private let DefaultContentHeight: CGFloat = 64

open class StickyHeaderView: UIView {
    
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
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil, let view = superview as? UIScrollView {
            view.removeObserver(self, forKeyPath:#keyPath(UIScrollView.contentOffset), context: &ContentOffsetContext)
            view.panGestureRecognizer.removeTarget(self, action: #selector(handlePan))
            appliedInsets = .zero
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let view = superview as? UIScrollView {
            view.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.initial, .new], context: &ContentOffsetContext)
            view.panGestureRecognizer.addTarget(self, action: #selector(StickyHeaderView.handlePan))
            view.sendSubview(toBack: self)
        }
    }

    fileprivate let contentContainer: UIView = {
        let view = UIView()
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        view.backgroundColor = .clear

        return view
    }()
    
    fileprivate let shadowView = HeaderShadowView(frame: .zero)
    
    @IBOutlet open var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.frame = contentContainer.bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                contentContainer.addSubview(view)
                contentContainer.sendSubview(toBack: view)
            }
        }
    }
    
    public enum ContentViewGravity {
        case top, center, bottom
    }
    
    /**
    Affects on `contentView` sticking position during view stretching: 
    
    - Top: `contentView` sticked to the top position of the view
    - Center: `contentView` is aligned to the middle of the streched view
    - Bottom: `contentView` sticked to the bottom
    
    Default value is `Center`
    **/
    open var contentViewGravity: ContentViewGravity = .center
    
    // MARK: - Background Image
    fileprivate let backgroundImageView = UIImageView()

    @IBInspectable
    open var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
            backgroundImageView.isHidden = backgroundImage == nil
        }
    }
    
    // MARK: - ScrollView
    fileprivate var scrollView: UIScrollView! { return superview as! UIScrollView }
    
    // MARK: - KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ContentOffsetContext {
            didScroll()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - State
    open var revealed: Bool = false {
        didSet {
            if oldValue != revealed {
                if revealed {
                    addInsets()
                } else {
                    removeInsets()
                }
            }
        }
    }
    
    fileprivate func setRevealed(_ revealed: Bool, animated: Bool, adjustContentOffset adjust: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                self.revealed = revealed
            }, completion: { completed in
                if adjust {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
                    }) 
                }
            })
        } else {
            self.revealed = revealed
            
            if adjust {
                scrollView.contentOffset.y = -scrollView.contentInset.top
            }
        }
    }
    
    open func setRevealed(_ revealed: Bool, animated: Bool) {
        setRevealed(revealed, animated: animated, adjustContentOffset: true)
    }

    fileprivate func fractionRevealed() -> CGFloat {
        return min(bounds.height / contentHeight, 1)
    }

    // MARK: - Applyied Insets
    fileprivate var appliedInsets: UIEdgeInsets = .zero
    fileprivate var insetsApplied: Bool {
        return appliedInsets != .zero
    }

    fileprivate func applyInsets(_ insets: UIEdgeInsets) {
        let originalInset = scrollView.contentInset - appliedInsets
        let targetInset = originalInset + insets

        appliedInsets = insets
        scrollView.contentInset = targetInset
    }
    
    fileprivate func addInsets() {
        assert(!insetsApplied, "Internal inconsistency")
        applyInsets(UIEdgeInsets(top: contentHeight, left: 0, bottom: 0, right: 0))
    }

    fileprivate func removeInsets() {
        assert(insetsApplied, "Internal inconsistency")
        applyInsets(.zero)
    }
    
    // MARK: - ContentHeight
    @IBInspectable open var contentHeight: CGFloat = DefaultContentHeight {
        didSet {
            if superview != nil {
                layoutToFit()
            }
        }
    }
    
    // MARK: - Threshold
    @IBInspectable open var threshold: CGFloat = 0.3
    
    // MARK: - Content Offset Hanlding
    fileprivate func applyContentContainerTransform(_ progress: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        let angle = (1 - progress) * CGFloat(M_PI_2)
        transform = CATransform3DRotate(transform, angle, 1, 0, 0)
        
        contentContainer.layer.transform = transform
    }
    
    fileprivate func didScroll() {
        layoutToFit()
        layoutIfNeeded()
        
        let progress = fractionRevealed()
        shadowView.alpha = 1 - progress

        applyContentContainerTransform(progress)
    }
    
    @objc fileprivate func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            let value = scrollView.normalizedContentOffset.y * (revealed ? 1 : -1)
            let triggeringValue = contentHeight * threshold
            let velocity = recognizer.velocity(in: scrollView).y
            
            if triggeringValue < value {
                let adjust = !revealed || velocity < 0 && -velocity < contentHeight
                setRevealed(!revealed, animated: true, adjustContentOffset: adjust)
            } else if 0 < bounds.height && bounds.height < contentHeight {
                UIView.animate(withDuration: 0.3, animations: {
                    self.scrollView.contentOffset.y = -self.scrollView.contentInset.top
                }) 
            }
        }
    }
    
    // MARK: - Layout
    open override func layoutSubviews() {
        super.layoutSubviews()

        backgroundImageView.frame = bounds
        
        let containerY: CGFloat
        switch contentViewGravity {
        case .top:
            containerY = min(bounds.height - contentHeight, bounds.minY)

        case .center:
            containerY = min(bounds.height - contentHeight, bounds.midY - contentHeight / 2)
            
        case .bottom:
            containerY = bounds.height - contentHeight
        }
        
        contentContainer.frame = CGRect(x: 0, y: containerY, width: bounds.width, height: contentHeight)
        // shadow should be visible outside of bounds during rotation
        shadowView.frame = contentContainer.bounds.insetBy(dx: -round(contentContainer.bounds.width / 16), dy: 0)
    }

    fileprivate func layoutToFit() {
        let origin = scrollView.contentOffset.y + scrollView.contentInset.top - appliedInsets.top
        frame.origin.y = origin
        
        sizeToFit()
    }
    
    open override func sizeThatFits(_: CGSize) -> CGSize {
        var height: CGFloat = 0
        if revealed {
            height = appliedInsets.top - scrollView.normalizedContentOffset.y
        } else {
            height = scrollView.normalizedContentOffset.y * -1
        }

        let output = CGSize(width: scrollView.bounds.width, height: max(height, 0))
        
        return output
    }
}
