// For License please refer to LICENSE file in the root of Persei project

import UIKit
import Persei

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var menu: MenuView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMenu()
        
        title = model.description
        //imageView.image = model.image
    }
    
    fileprivate func loadMenu() {
        menu = {
            let menu = MenuView.init()
            menu.delegate = self
            menu.items = items
            
            return menu
        }()
        
        collectionView.addSubview(menu)
    }
    
    // MARK: - Items
    fileprivate let items = (0..<7).map {
        MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
    }
    
    // MARK: - Model
    fileprivate var model: ContentType = .films {
        didSet {
            title = model.description
            collectionView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction fileprivate func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = model.image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
}

// MARK: - MenuViewDelegate

extension CollectionViewController: MenuViewDelegate {
    
    func menu(_ menu: MenuView, didSelectItemAt index: Int) {
        model = model.next()
    }
}
