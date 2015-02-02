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
    private weak var menu: MenuView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMenu()
        
        imageView.image = UIImage(named: model.rawValue)
    }
    
    private func loadMenu() {
        let menu = MenuView()
        menu.delegate = self
        menu.items = items
        
        tableView.addSubview(menu)
        
        self.menu = menu
    }
    
    // MARK: - Items
    private let items = (0..<7 as Range).map {
        MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
    }
    
    // MARK: - Model
    private var model: ContentType = ContentType.Films {
        didSet {
            if isViewLoaded() {
                imageView.image = UIImage(named: model.rawValue)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction
    private func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
    }
}

// MARK: - MenuViewDelegate
extension ViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
        model = !model
    }
}