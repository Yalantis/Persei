// For License please refer to LICENSE file in the root of Persei project

import UIKit
import QuartzCore
import CoreImage
import Persei

class ViewController: UITableViewController {
    
    @IBOutlet
    fileprivate weak var imageView: UIImageView!
    fileprivate weak var menu: MenuView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMenu()
        
        title = model.description
        imageView.image = model.image
    }
    
    fileprivate func loadMenu() {
        let menu = MenuView()
        menu.delegate = self
        menu.items = items
        
        tableView.addSubview(menu)
        
        self.menu = menu
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(imageView.bounds.size)
    }
    
    // MARK: - Items
    fileprivate let items = (0..<7).map {
        MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
    }
    
    // MARK: - Model
    fileprivate var model: ContentType = ContentType.Films {
        didSet {
            title = model.description
            
            if isViewLoaded {
                let center: CGPoint = {
                    let itemFrame = self.menu.frameOfItemAtIndex(self.menu.selectedIndex!)
                    let itemCenter = CGPoint(x: itemFrame.midX, y: itemFrame.midY)
                    var convertedCenter = self.imageView.convert(itemCenter, from: self.menu)
                    convertedCenter.y = 0

                    return convertedCenter
                }()
                
                let transition = CircularRevealTransition(layer: imageView.layer, center: center)
                transition.start()
                
                imageView.image = model.image
            }
        }
    }
    
    // MARK: - Actions
    @IBAction
    fileprivate func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
    }
}

// MARK: - MenuViewDelegate
extension ViewController: MenuViewDelegate {
    func menu(_ menu: MenuView, didSelectItemAtIndex index: Int) {
        model = model.next()
    }
}
