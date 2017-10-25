// For License please refer to LICENSE file in the root of Persei project

import UIKit

class MenuCell: UICollectionViewCell {
    
    private let shadowView = UIView()
    private let imageView = UIImageView()
    private var value: MenuItem!

    // MARK: - Init
    private func commonInit() {
        backgroundView = UIView()
        
        let views = ["imageView": imageView, "shadowView": shadowView]
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "|-[imageView]-|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[imageView]-|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shadowView)
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "|[shadowView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[shadowView(2)]|",
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
        
        value = nil
    }
    
    func apply(_ value: MenuItem) {
        self.value = value
        
        imageView.image = value.image
        imageView.highlightedImage = value.highlightedImage
        shadowView.backgroundColor = value.shadowColor
        
        updateSelectionVisibility()
    }
    
    // MARK: - Selection
    private func updateSelectionVisibility() {
        imageView.isHighlighted = isSelected
        backgroundView?.backgroundColor = isSelected ? value?.highlightedBackgroundColor : value?.backgroundColor
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionVisibility()
        }
    }
}
