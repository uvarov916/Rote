//
//  AddCard.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit
import CoreData

class AddCardViewController: UIViewController, UITextViewDelegate {
    
    // MARK: VARIABLES
    
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var actionBarButton: UIBarButtonItem!
    @IBOutlet var confirmationMessage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        confirmationMessage.alpha = 0.0
    }
    
    // MARK: INITIALIZATION:
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: TEXTVIEW DELEGATE
    
    func textViewDidChange(textView: UITextView) {
        // Check length of both textfields, and only enable button if they contain text
        if countElements(questionTextView.text) > 0 && countElements(answerTextView.text) > 0 {
            actionBarButton.enabled = true
        } else {
            actionBarButton.enabled = false
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        // Check for placeholder text, if it's there, remove it
        if textView.text == "Enter the question here" || textView.text == "Enter the correct answer here" {
            textView.text = ""
            if textView == questionTextView {
                textView.textColor = UIColor.whiteColor()
            } else {
                textView.textColor = UIColor.blackColor()
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // Check for empty, if it is, enter placeholder text
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            if textView == questionTextView {
                textView.text = "Enter the question here"
            } else {
                textView.text = "Enter the correct answer here"
            }
        }
    }
    
    // MARK: ACTIONS

    @IBAction func saveAction(sender: AnyObject) {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newFlashcard = NSEntityDescription.insertNewObjectForEntityForName("Flashcards", inManagedObjectContext: context) as NSManagedObject
        
        newFlashcard.setValue(questionTextView.text, forKey: "question")
        newFlashcard.setValue(answerTextView.text, forKey: "answer")
        newFlashcard.setValue(0, forKey: "current_interval")
        newFlashcard.setValue(2.5, forKey: "efactor")
        newFlashcard.setValue(0, forKey: "times_reviewed")
        
        let currentDate: NSDate = NSDate()
        // adding interval time to get the next date
        // var nextDate: NSDate = NSDate().dateByAddingTimeInterval(60)
        newFlashcard.setValue(currentDate, forKey: "next_date")
        
        UIView.animateWithDuration(1, animations: {
            self.confirmationMessage.alpha = 1.0
        })
        
        UIView.animateWithDuration(1, animations: {
            self.confirmationMessage.alpha = 0
        })
        
        context.save(nil)
        
        
        
        println("-------------- ADDED NEW DATA --------------")
        println(newFlashcard)
        println("Object Saved.")
        
        questionTextView.text = ""
        answerTextView.text = ""
        
        questionTextView.becomeFirstResponder()
        
    }
}
