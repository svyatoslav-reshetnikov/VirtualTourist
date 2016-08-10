//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by SVYAT on 10.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var photos: NSSet?

}
