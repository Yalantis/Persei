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

//        tableView.contentInset.top = 64.0
        
        let barView = BarView()
        barView.backgroundColor = UIColor.yellowColor()
        tableView.addSubview(barView)
    }
}

