//
//  ViewController.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let whoSucks = "Ivan"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("You suck \(whoSucks)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}