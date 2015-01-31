//
// Created by zen on 30/01/15.
// Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit

public class MenuView: StickyHeaderView {

    // MARK: - FlowLayout
    private lazy var collectionLayout: UICollectionViewFlowLayout = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.contentHeight, height: self.contentHeight)
        
        return layout
    }()
    
    // MARK: - CollectionView
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)

        view.delegate = self
        view.dataSource = self
        
        self.contentView = view

        return view
    }()

    // TODO: remove explicit type declaration when compiler error will be fixed
    public var items: [MenuItem] = [] {
        didSet {
            collectionView.reloadData()
            selectedIndex = items.count > 0 ? 0 : nil
        }
    }

    public var selectedIndex: Int? = 0 {
        didSet {
            
        }
    }
    
    // MARK: - ContentHeight
    
    public override var contentHeight: CGFloat {
        didSet {
            collectionLayout.itemSize = CGSize(width: contentHeight, height: contentHeight)
        }
    }
    
}

extension MenuView: UICollectionViewDataSource {

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    // The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//    optional func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
//    
}

extension MenuView: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

}
