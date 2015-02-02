//
//  ViewController.swift
//  Example
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import Persei

class ViewController: UITableViewController {
    @IBOutlet
    private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuView()
        menu.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
        
        menu.items = (0..<7 as Range).map {
            MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
        }
    
        tableView.addSubview(menu)
    }
}

// MARK: - MenuViewDelegate
extension ViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
        
    }
}