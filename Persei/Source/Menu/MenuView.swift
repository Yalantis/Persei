// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit

private let CellIdentifier = "MenuCell"
private let DefaultContentHeight: CGFloat = 112.0

public class MenuView: StickyHeaderView {
    // MARK: - Init
    override func commonInit() {
        super.commonInit()
        
        if backgroundColor == nil {
            backgroundColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 76 / 255, alpha: 1)
        }

        contentHeight = DefaultContentHeight
        
        updateContentLayout()
    }
    
    // MARK: - FlowLayout
    private lazy var collectionLayout: UICollectionViewFlowLayout = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        
        return layout
    }()
    
    // MARK: - CollectionView
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: self.collectionLayout)
        view.clipsToBounds = false
        view.backgroundColor = UIColor.clearColor()
        view.showsHorizontalScrollIndicator = false
        view.registerClass(MenuCell.self, forCellWithReuseIdentifier: CellIdentifier)

        view.delegate = self
        view.dataSource = self
        
        self.contentView = view
        
        return view
    }()
    
    // MARK: - Delegate
    @IBOutlet
    public weak var delegate: MenuViewDelegate?

    // TODO: remove explicit type declaration when compiler error will be fixed
    public var items: [MenuItem] = [] {
        didSet {
            collectionView.reloadData()
            selectedIndex = items.count > 0 ? 0 : nil
        }
    }

    public var selectedIndex: Int? = 0 {
        didSet {
            var indexPath: NSIndexPath?
            if let index = self.selectedIndex {
                indexPath = NSIndexPath(forItem: index, inSection: 0)
            }
            
            self.collectionView.selectItemAtIndexPath(indexPath,
                animated: self.revealed,
                scrollPosition: .CenteredHorizontally
            )
        }
    }
    
    // MARK: - ContentHeight & Layout
    public override var contentHeight: CGFloat {
        didSet {
            updateContentLayout()
        }
    }
    
    private func updateContentLayout() {
        let inset = ceil(contentHeight / 6.0)
        let spacing = floor(inset / 2.0)
    
        collectionLayout.minimumLineSpacing = spacing
        collectionLayout.minimumInteritemSpacing = spacing
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)

        collectionLayout.itemSize = CGSize(width: contentHeight - inset * 2, height: contentHeight - inset * 2)
    }
}

extension MenuView {
    public func frameOfItemAtIndex(index: Int) -> CGRect {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        let layoutAttributes = collectionLayout.layoutAttributesForItemAtIndexPath(indexPath)!
        
        return self.convertRect(layoutAttributes.frame, fromView: collectionLayout.collectionView)
    }
}

extension MenuView: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            CellIdentifier,
            forIndexPath: indexPath
        ) as? MenuCell

        // compatibility with Swift 1.1 & 1.2
        cell?.object = items[indexPath.item]
        
        return cell!
    }
}

extension MenuView: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.item
        delegate?.menu(self, didSelectItemAtIndex: selectedIndex!)
        
        UIView.animateWithDuration(0.2, delay: 0.4, options: [], animations: {
            self.revealed = false
        }, completion: nil)
    }
}
