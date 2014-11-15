//
//  AddCard.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit
import CoreData

class AddCardViewController: UIViewController {
    
    @IBOutlet var txtQuestion: UITextField!
    @IBOutlet var txtAnswer: UITextField!
    
    @IBAction func addNewCard() {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newFlashcard = NSEntityDescription.insertNewObjectForEntityForName("Flashcards", inManagedObjectContext: context) as NSManagedObject
        
        newFlashcard.setValue(txtQuestion.text, forKey: "question")
        newFlashcard.setValue(txtAnswer.text, forKey: "answer")
        
        context.save(nil)
        
        println(newFlashcard)
        println("Object Saved.")
        
        txtQuestion.text = ""
        txtAnswer.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
