//
//  EntryMangedObject+CoreDataProperties.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//

import Foundation
import CoreData


extension EntryManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntryManagedObject> {
        return NSFetchRequest<EntryManagedObject>(entityName: "Entries");
    }
    
    @NSManaged public var sentence: String?
    @NSManaged public var image: NSData?
    
    
}
