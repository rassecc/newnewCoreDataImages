//
//  EntryCoreData.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//


import Foundation
import UIKit
import CoreData
class EntryCoreData {
    static let entryData = EntryCoreData()
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext : NSManagedObjectContext?
    var entity : NSEntityDescription?
    var entryInput : EntryManagedObject?
    
    init(){
        self.managedContext = (self.appDelegate?.persistentContainer.viewContext)!
        self.entity = NSEntityDescription.entity(forEntityName: "Entries", in: managedContext!)!
        
    }
    func fetchRequest() -> [EntryManagedObject] {
        let request = NSFetchRequest<EntryManagedObject>(entityName: "Entries")
        do {
            let results = try self.managedContext?.fetch(request)
            return results!
        } catch {
            
        }
        return [EntryManagedObject].init()
    }
    func insert(entryInput : EntryManagedObject) -> Void {
        self.managedContext?.insert(entryInput)
    }
    func delete(entryInput : EntryManagedObject) -> Void {
        self.managedContext?.delete(entryInput)
    }
    
    func refresh(entryInput : EntryManagedObject) -> Void {
        self.managedContext?.refresh(entryInput, mergeChanges: true)
    }
    
    func newEntry() -> EntryManagedObject {
        return EntryManagedObject(entity: entity!, insertInto: self.managedContext)
    }
    
    func save() -> Void {
        do{
            try self.managedContext?.save()
        }catch {
            
        }
    }
}
