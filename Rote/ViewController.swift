//
//  ViewController.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: VARIABLES
    
    @IBOutlet var underNavigationBar: UIView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var cardsButton: UIButton!
    @IBOutlet var buttonFooter: UIView!
    @IBOutlet var answerPlaceholderLabel: UILabel!
    
    var tgr: UITapGestureRecognizer!
    var flashcards = [NSManagedObject]()
    var managedContext: NSManagedObjectContext!
    
    // MARK: INITIALIZATION

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tgr = UITapGestureRecognizer(target: self, action: "showAnswer")
        self.view.addGestureRecognizer(tgr)
        
        self.getFlashcardInfo()
    }
    
    func getFlashcardInfo() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if managedContext == nil {
            managedContext = appDelegate.managedObjectContext!
        }
        let fetchRequest = NSFetchRequest(entityName: "Flashcards")
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            flashcards = results
            self.updateQuestion()
        } else {
            println("Could not fetch \(error),  \(error!.userInfo)")
        }
    }
    
    func updateQuestion() {
        answerPlaceholderLabel.hidden = false
        answerTextView.hidden = true
        cardsButton.hidden = false
        buttonFooter.hidden = true
        
        if flashcards.count > 0 {
            let flashcard: NSManagedObject = flashcards[0] as NSManagedObject
        
            titleTextView.text = flashcard.valueForKey("question") as String
            answerTextView.text = flashcard.valueForKey("answer") as String
        } else {
            titleTextView.text = "No more flashcards for now"
            answerPlaceholderLabel.text = "Come back later for more"
            answerPlaceholderLabel.textAlignment = NSTextAlignment.Center
            self.view.removeGestureRecognizer(tgr)
        }
    }
    
    // MARK: INTERACTION
    
    func showAnswer() {
        answerPlaceholderLabel.hidden = true
        answerTextView.hidden = false
        cardsButton.hidden = true
        buttonFooter.hidden = false
        
        self.view.removeGestureRecognizer(tgr)
    }
    
    @IBAction func tappedRightButton(sender: AnyObject) {
        flashcards.removeAtIndex(0)
        self.view.addGestureRecognizer(tgr)
        self.updateQuestion()
    }

    @IBAction func tappedNotSureButton(sender: AnyObject) {
        flashcards.removeAtIndex(0)
        self.view.addGestureRecognizer(tgr)
        self.updateQuestion()
    }
    
    @IBAction func tappedWrongButton(sender: AnyObject) {
        flashcards.removeAtIndex(0)
        self.view.addGestureRecognizer(tgr)
        self.updateQuestion()
    }
}