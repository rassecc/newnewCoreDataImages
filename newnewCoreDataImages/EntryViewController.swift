//
//  ViewController.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//

import UIKit
import Foundation

class EntryViewController: UIViewController, UITabBarDelegate, UITableViewDataSource{
    
   

    @IBOutlet weak var tableView: UITableView!
    
    let entryCD = EntryCoreData.init()
   // let images = [#imageLiteral(resourceName: "corg1"), #imageLiteral(resourceName: "corg2"), #imageLiteral(resourceName: "corg3"), #imageLiteral(resourceName: "corg4"), #imageLiteral(resourceName: "corg5")]
    let imageURLs : [String] = ["https://www.free-pictures-photos.com/flower-07.jpg", "https://wallpaperscraft.com/image/puppy_cute_face_eyes_doggy_81737_1920x1080.jpg", "http://cdn.wallpapersafari.com/81/56/gf5n3T.jpg", "https://www.free-pictures-photos.com/dolphinfreeimages.jpg", "http://free4kwallpaper.com/wp-content/uploads/2016/01/Doggy-Love-4K-Wallpaper.jpg", "http://i.imgur.com/cII79Yrb.jpg"]
    
    var items = [[AnyObject]]()
    var buttonSection : Array<Int> = Array(repeating: 0, count : 1)

    var bSectionIndex : Int?
    var dSectionIndex : Int?
    
    var indexPath = IndexPath()
    
    
    var imageCache = NSCache<AnyObject, AnyObject>()

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //clear cache once a warning is given
        self.imageCache.removeAllObjects()
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.bSectionIndex = self.items.count
        self.items.append(self.buttonSection as [AnyObject])
        self.dSectionIndex = self.items.count
        self.items.append(self.entryCD.fetchRequest())
    }
    
    
    @IBAction func addButton(_ sender: UIButton) {
        setUpAlertBoxes()
    }
    
    func setUpAlertBoxes(){
        let alertController = UIAlertController(title: "New Entry", message: "What would you like to input", preferredStyle: .alert)

        alertController.addTextField { (hoursWorkedTextField) in hoursWorkedTextField.placeholder = " "}

        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            print("ok has been pressed")
            
            let row = self.items[self.dSectionIndex!].count
            let indexPath = [IndexPath.init(row: row, section: self.dSectionIndex!)]
            var entryInput : EntryManagedObject?

            entryInput = self.entryCD.newEntry()

            entryInput?.sentence = alertController.textFields![0].text!
         //   entryInput?.image = UIImagePNGRepresentation(self.imageSaved) as NSData?
            
            self.items[self.dSectionIndex!].append(entryInput!)
            self.tableView.insertRows(at: indexPath, with: .automatic)

            self.entryCD.save()
            self.tableView.reloadData()
            
            

        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            print ("cancel has been pressed")
            for textField in alertController.textFields! {
                textField.text = ""
            }
        })
        
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }


    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case self.bSectionIndex!:
            return "Add a new entry"
        case self.dSectionIndex!:
            return "Entries"
        default:
            return "Section"
        }
    }
    
    @nonobjc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0 && indexPath.section == 0){
            setUpAlertBoxes()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            
            case self.bSectionIndex! :
                let cellIdentifier = "buttonCell"
                let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! buttonCell
                return cell
            
            
            case self.dSectionIndex! :
                let cellIdentifier = "cell"
                let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! cell
                let entryInput = self.items[self.dSectionIndex!][indexPath.row] as! EntryManagedObject
                cell.sentence.text = entryInput.sentence

                let num  = Int(arc4random_uniform(5))
                let imageURL = self.imageURLs[num]
                let url = URL(string: imageURL)
 
                if entryInput.image == nil {
                    if let image = imageCache.object(forKey: self.imageURLs[num] as AnyObject) as? UIImage {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let imageData: NSData? = UIImageJPEGRepresentation(image, 1) as NSData?
                            entryInput.image = imageData
                            if (cell.imagee.image == nil){
                                cell.imagee.image = image
                            }
                            print("grabbed from cache")
                        })
                    }
                    else {
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                            if error != nil {
                                print("oh no")
                                return
                            }
                            let image = UIImage(data : data!)
                            self.imageCache.setObject(image!, forKey: self.imageURLs[num] as AnyObject)
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                              
                                let imageData: NSData? = UIImageJPEGRepresentation(image!, 1) as NSData?
                                entryInput.image = imageData
                                if (cell.imagee.image == nil){
                                    cell.imagee.image = image
                                }

                                print("downloaded and put into cache")
                            })
                        
                        }).resume()
                    
                    }
                }
                else{
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        if cell.imagee.image == nil{
                            let imageee = UIImage(data: entryInput.image as! Data, scale: 1.0)
                            cell.imagee.image = imageee
                        }
                        
                        
                       // print("grabbed image from CD object: " + entryInput.sentence!)
                    })
                }
               
                return cell
            
            default :
                let cellIdentifier = "cell"
                let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! cell
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            if indexPath.section == self.dSectionIndex {
                let entryInput = self.items[self.dSectionIndex!][indexPath.row]
                self.items[self.dSectionIndex!].remove(at: indexPath.row)
                self.entryCD.delete(entryInput: entryInput as! EntryManagedObject)
                self.entryCD.save()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

