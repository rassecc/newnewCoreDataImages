//
//  ViewController.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//

import UIKit
import Foundation

class realViewController: UITableViewController {
    
    let entryCD = EntryCoreData.init()
    let images = [#imageLiteral(resourceName: "corg1"), #imageLiteral(resourceName: "corg2"), #imageLiteral(resourceName: "corg3"), #imageLiteral(resourceName: "corg4"), #imageLiteral(resourceName: "corg5")]
    
    var items = [[AnyObject]]()
    var buttonSection : Array<Int> = Array(repeating: 0, count : 1)
    var dataSection = [Entry]()
    var bSectionIndex = Int()
    var dSectionIndex = Int()
    
    var indexPath = IndexPath()
    var isEditingTable : Bool?
    
    let newItemAlertController = UIAlertController(title: "New Work Day", message: "Enter the date and it's respective work schedule", preferredStyle: .alert)
    
    @IBAction func addButton(_ sender: Any) {
        self.newItemAlertController.title = "New Work Day"
        self.present(newItemAlertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 50
        
        self.bSectionIndex = self.items.count
        self.items.append(self.buttonSection as [AnyObject])
        self.dSectionIndex = self.items.count
        self.items.append(self.entryCD.fetchRequest())
        setUpAlertBoxes()
    }
    
    func setUpAlertBoxes() -> Void{
        //        self.newItemAlertController.addTextField { (dateTextField) in
        //            dateTextField.placeholder = "Date"
        //        }
        self.newItemAlertController.addTextField { (hoursWorkedTextField) in
            hoursWorkedTextField.placeholder = "Hours worked"
        }
        //
        //insert and edit are executed here
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction) in print("ok has been pressed")
            
            let row = self.items[self.dSectionIndex].count
            let indexPath = [IndexPath.init(row: row, section: self.dSectionIndex)]
            var workDay : EntryManagedObject?
            
            //Check if editing or adding a new entry
            if !self.isEditingTable! {
                workDay = self.entryCD.getNewDay()         //new entry -- get a new WorkScheduleManagedObject
            } else {
                workDay = self.items[self.dSectionIndex][self.indexPath.row] as? EntryManagedObject
            }
            
            workDay?.sentence = "lol"
            //     workDay?.date = self.newItemAlertController.textFields![0].text!
            //  workDay?.hoursWorked = self.newItemAlertController.textFields![1].text!
            
            if !self.isEditingTable! { //adding new entry
                print("new entry: row to be insert \(row)")
                workDay?.image = UIImagePNGRepresentation(self.images[Int(arc4random_uniform(UInt32(self.items.count)))]) as NSData?
                self.items[self.dSectionIndex].append(workDay!)
                self.tableView.insertRows(at: indexPath, with: .automatic)
            } else { //editing existing entry
                print ("editing")
                self.entryCD.refresh(workDay: workDay!)
                self.items[self.dSectionIndex][self.indexPath.row] = workDay!
                self.tableView.reloadRows(at: [self.indexPath], with: .automatic)
            }
            self.entryCD.save()
            self.isEditingTable = false
            
            //reset the boxes
            for textField in self.newItemAlertController.textFields! {
                textField.text = ""
            }
        }) // End of actionOK definition
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction) in print ("cancel has been pressed")
            for textField in self.newItemAlertController.textFields! {
                textField.text = ""
            }
        })
        
        self.newItemAlertController.addAction(actionOK)
        self.newItemAlertController.addAction(actionCancel)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch(section){
        case self.bSectionIndex:
            return "Add new day"
        case self.dSectionIndex:
            return "Work History"
        default:
            return "Section"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            
        case self.bSectionIndex :
            let cellIdentifier = "ButtonTableViewCell"
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! buttonCell
            return cell
            
        case self.dSectionIndex :
            let cellIdentifier = "DataTableViewCell"
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! cell
            let entryy = self.items[self.dSectionIndex][indexPath.row] as! EntryManagedObject
            cell.entry.text = entryy.sentence
            //    cell.dateLabel.text = workDay.date
            //cell.hoursWorkedLabel.text = "Hours Worked : \(workDay.hoursWorked!)"
            DispatchQueue.global(qos: .background).async { //run in background
                if entryy.image == nil {
                    entryy.image = UIImagePNGRepresentation(self.images[Int(arc4random_uniform(UInt32(self.items.count)))]) as NSData?
                }
                cell.imagee.image = UIImage(data: entryy.image as! Data)
                cell.imagee.isHidden = false
            }
            return cell
            
        default :
            let cellIdentifier = "DataTableViewCell"
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! cell
            return cell
            
            
        }
    }
    
    
    
}

