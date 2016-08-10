//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var image: NSData?
    @NSManaged var pin: Pin?

}
