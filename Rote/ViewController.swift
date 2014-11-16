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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        titleTextView.alpha = 0
        answerPlaceholderLabel.alpha = 0
        answerTextView.alpha = 0
    }
    
    func updateFlashcardAfterReview(flashcard: NSManagedObject, responseQuality: Int) {
        
        // getting old values
        let currentNumberReviewed: Int = flashcard.valueForKey("times_reviewed")! as Int
        let currentInterval: Int = flashcard.valueForKey("current_interval")! as Int
        let currentEFactor: Double = flashcard.valueForKey("efactor")! as Double
        
        // variables for new values
        var newInterval: Int = 0
        var newEFactor: Double = 0.0
        var newNumberReviewed: Int = 0
        var newDate: NSDate
        
        
        // incrementing number of ties the flashcard was reviewed
        if (responseQuality == 0) {
            newNumberReviewed = 0
        }
        else {
            newNumberReviewed = currentNumberReviewed + 1
        }
        
        
        // Calculates new E-Factor
        let temp: Double = Double(5 - responseQuality)
        newEFactor = currentEFactor + (0.1 - temp * (0.08 + temp * 0.02))
        if (newEFactor < 1.3) {
            newEFactor = 1.3
        }
        
        // Calculates new interval
        if (newNumberReviewed <= 5) { // default intervals
            
            switch newNumberReviewed {
            case 0:
                newInterval = 60 // 1 minute
            case 1:
                newInterval = 300 // 5 minutes
            case 2:
                newInterval = 600 // 10 minutes
            case 3:
                newInterval = 900 // 15 minutes
            case 4:
                newInterval = 86400 // 1 day
            case 5:
                newInterval = 86400 * 6 // 6 days
            default:
                println("Something is wrong with review counter")
            }
        }
        else { // interval requires calculation
            newInterval = Int(round(Double(currentInterval) * newEFactor))
        }
        
        newDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(newInterval))
        println("DATE DATE DATE DATE DATE DATE: \(newDate)")
        
        // updating values
        flashcard.setValue(newNumberReviewed, forKey: "times_reviewed")
        flashcard.setValue(newEFactor, forKey: "efactor")
        flashcard.setValue(newInterval, forKey: "current_interval")
        flashcard.setValue(newDate, forKey: "next_date")
        
        managedContext.save(nil)
        
        println("!!!!!!!!!!!!! Updated !!!!!!!!!!!!!")
        println(flashcard)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tgr = UITapGestureRecognizer(target: self, action: "showAnswer")
        self.view.addGestureRecognizer(tgr)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.getFlashcardInfo()
    }
    
    func getFlashcardInfo() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if managedContext == nil {
            managedContext = appDelegate.managedObjectContext!
        }
        var fetchRequest = NSFetchRequest(entityName: "Flashcards")
        
        let currentDate: NSDate = NSDate()
        fetchRequest.predicate = NSPredicate(format: "next_date < %@", argumentArray: [currentDate])
        let sortDescriptor = NSSortDescriptor(key: "next_date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            flashcards = results
            self.updateQuestion()
        } else {
            println("Could not fetch \(error),  \(error!.userInfo)")
            tgr.enabled = false
        }
    }
    
    func updateQuestion() {
        answerPlaceholderLabel.hidden = false
        answerTextView.hidden = true
        cardsButton.hidden = false
        buttonFooter.hidden = true
        
        if flashcards.count > 0 {
            let flashcard: NSManagedObject = flashcards[0] as NSManagedObject
            
            titleTextView.alpha = 0
            answerTextView.alpha = 0
            answerPlaceholderLabel.alpha = 0

            titleTextView.text = flashcard.valueForKey("question") as String
            titleTextView.textAlignment = NSTextAlignment.Left
            answerTextView.text = flashcard.valueForKey("answer") as String
            answerPlaceholderLabel.text = "Tap anywhere to see the answer"
            
            
            UIView.animateWithDuration(0.3, animations: {
                self.titleTextView.alpha = 1.0
                self.answerTextView.alpha = 1.0
                self.answerPlaceholderLabel.alpha = 1.0
            })
            
            
            
            
            tgr.enabled = true;
        
        } else {
            titleTextView.alpha = 0
            answerPlaceholderLabel.alpha = 0
            
            titleTextView.text = "No more flashcards for now"
            titleTextView.textAlignment = NSTextAlignment.Center
            answerPlaceholderLabel.text = "Come back later for more"
            answerPlaceholderLabel.textAlignment = NSTextAlignment.Center
            tgr.enabled = false
            
            UIView.animateWithDuration(0.3, animations: {
                self.titleTextView.alpha = 1.0
                self.answerPlaceholderLabel.alpha = 1.0
            })
        }
    }
    
    // MARK: INTERACTION
    
    func showAnswer() {
        
        answerPlaceholderLabel.hidden = true
        answerTextView.hidden = false
        cardsButton.hidden = true
        buttonFooter.hidden = false
        
        tgr.enabled = false
    }
    
    @IBAction func tappedRightButton(sender: AnyObject) {
        updateFlashcardAfterReview(flashcards[0], responseQuality: 5)
        
        flashcards.removeAtIndex(0)
        tgr.enabled = true
        self.updateQuestion()
    }

    @IBAction func tappedNotSureButton(sender: AnyObject) {
        updateFlashcardAfterReview(flashcards[0], responseQuality: 3)
        
        flashcards.removeAtIndex(0)
        tgr.enabled = true
        self.updateQuestion()
    }
    
    @IBAction func tappedWrongButton(sender: AnyObject) {
        updateFlashcardAfterReview(flashcards[0], responseQuality: 0)
        
        flashcards.removeAtIndex(0)
        tgr.enabled = true
        self.updateQuestion()
    }
}