//
//  EditCardViewController.swift
//  Rote
//
//  Created by Aleksander Skjølsvik on 15.11.14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit
import CoreData

class EditCardViewController2: UIViewController {
    
    var flashCard: NSManagedObject!
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var actionBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextView.text = flashCard.valueForKey("question") as String
        answerTextView.text = flashCard.valueForKey("answer") as String
    }
    
    @IBAction func editCard(sender: AnyObject) {
        questionTextView.becomeFirstResponder()
        
        actionBarButtonItem.title = "Save"
        actionBarButtonItem.action = "saveCard:"
    }
    
    func saveCard(sender: AnyObject) {
        flashCard.setValue(questionTextView.text, forKey: "question")
        flashCard.setValue(answerTextView.text, forKey: "answer")
        
        var error: NSError?
        managedContext.save(&error)
        if error == nil {
            println("Object saved successfully")
            navigationController?.popViewControllerAnimated(true)
        } else {
            println("Error saving object \(error)")
        }
    }
}