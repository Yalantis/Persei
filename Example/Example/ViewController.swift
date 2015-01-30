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
        
        let barView = StickHeaderView()
        let button = UIButton()
        button.setTitle("Hello", forState: .Normal)
        button.backgroundColor = UIColor.redColor()
        barView.contentView = button
        
        barView.backgroundColor = UIColor.grayColor()
        tableView.addSubview(barView)
    }
}

