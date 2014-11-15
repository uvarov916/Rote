//
//  ViewController.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var underNavigationBar: UIView!
    @IBOutlet var titleTextView: UITextView!
    
    let whoSucks = "Ivan"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextView.text = "You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan v You suck ivanv You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan v You suck ivanv You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan You suck ivan"
        
        /*let contentSizeHeight = titleTextView.contentSize.height
        var navBarFrame = underNavigationBar.frame
        navBarFrame.size.height = contentSizeHeight + 600
        underNavigationBar.frame = navBarFrame*/
        titleTextView.sizeToFit()
        println("\(underNavigationBar.frame.size.height), \(titleTextView.frame.size.height)")
        underNavigationBar.frame.size.height = titleTextView.frame.size.height + 120
        
        
        //self.navigationController?.navigationBar.hidden = true
        
        println("You suck \(whoSucks)")

    }

}