//
//  ViewController.swift
//  Example
//
//  Created by zen on 28/01/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import Persei

class ViewController: UIViewController {

    @IBOutlet
    private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset.top = 64.0
        
        let menu = MenuView()
        menu.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
        
        menu.items = (0..<7 as Range).map {
            MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
        }
    
        tableView.addSubview(menu)
    }
}

