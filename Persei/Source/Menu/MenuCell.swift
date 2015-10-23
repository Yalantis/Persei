// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit

class MenuCell: UICollectionViewCell {
    // MARK: - Init
    private func commonInit() {
        backgroundView = UIView()
        
        let views: [String: AnyObject] = ["imageView": imageView, "shadowView": shadowView]
        
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "|-[imageView]-|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[imageView]-|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shadowView)
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "|[shadowView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[shadowView(2)]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        object = nil
    }
    
    // MARK: - ShadowView
    private let shadowView = UIView()
    
    // MARK: - ImageView
    private let imageView = UIImageView()
    
    // MARK: - Object
    var object: MenuItem? {
        didSet {
            imageView.image = object?.image
            imageView.highlightedImage = object?.highlightedImage
            shadowView.backgroundColor = object?.shadowColor
            
            updateSelectionVisibility()
        }
    }
    
    // MARK: - Selection
    private func updateSelectionVisibility() {
        imageView.highlighted = selected
        backgroundView?.backgroundColor = selected ? object?.highlightedBackgroundColor : object?.backgroundColor
    }
    
    override var selected: Bool {
        didSet {
            updateSelectionVisibility()
        }
    }
}