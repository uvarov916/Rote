//
//  CardsViewController.swift
//  Rote
//
//  Created by Ivan Uvarov on 11/15/14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit
import CoreData

class CardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: VARIABLES
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var questionLabel: UILabel!
    
    var flashcards = [NSManagedObject]()
    var managedContext: NSManagedObjectContext!
    
    // MARK: INITIALIZATION

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 67
        tableView.rowHeight = UITableViewAutomaticDimension

        self.navigationItem.hidesBackButton = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()  
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        } else {
            println("Could not fetch \(error),  \(error!.userInfo)")
        }
        
    }
    
    // MARK: TABLEVIEW
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reusableCell") as CustomTableViewCell
        
        let flashcard = flashcards[indexPath.row]
        cell.questionLabel.text = flashcard.valueForKey("question") as String!
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let flashcard = flashcards[indexPath.row]
        let question = flashcard.valueForKey("question") as String!
        
        self.performSegueWithIdentifier("editCardSegue", sender: self)
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    // MARK: NAVIGATION
    
    @IBAction func backToStudy() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editCardSegue" {
            let vc:EditCardViewController2 = segue.destinationViewController as EditCardViewController2
            let indexPath = tableView.indexPathForSelectedRow()
            vc.flashCard = flashcards[indexPath!.row]
            vc.managedContext = managedContext
        }
    }
}