//
//  MenuCell.swift
//  Persei
//
//  Created by zen on 31/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UICollectionViewCell {
    // MARK: - Init
    private func commonInit() {
        backgroundView = UIView()
        
        let views: [NSObject: AnyObject] = ["imageView": imageView, "shadowView": shadowView]
        
        imageView.contentMode = .ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(imageView)
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "|-[imageView]-|",
                options: nil,
                metrics: nil,
                views: views
            )
        )
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[imageView]-|",
                options: nil,
                metrics: nil,
                views: views
            )
        )
        
        shadowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(shadowView)
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "|[shadowView]|",
                options: nil,
                metrics: nil,
                views: views
            )
        )
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[shadowView(2)]|",
                options: nil,
                metrics: nil,
                views: views
            )
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
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

            backgroundView?.backgroundColor = object?.backgroundColor
            shadowView.backgroundColor = object?.shadowColor
        }
    }

    // MARK: - Selection
    override var selected: Bool {
        didSet {
            imageView.highlighted = selected
            backgroundView?.backgroundColor = selected ? object?.highlightedBackgroundColor : object?.backgroundColor
        }
    }
}