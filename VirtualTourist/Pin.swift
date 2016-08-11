//
//  Pin.swift
//  VirtualTourist
//
//  Created by SVYAT on 10.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Pin)
class Pin: NSManagedObject {

    static func savePin(annotation: MKAnnotation, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
            let pin = Pin(entity: ent, insertIntoManagedObjectContext: context)
            pin.lat = annotation.coordinate.latitude
            pin.lon = annotation.coordinate.longitude
            
            do {
                try context.save()
            } catch let error as NSError  {
                fatalError("Could not save \(error), \(error.userInfo)")
            }
        } else {
            fatalError("Unable to find entity name!")
        }
    }
    
    static func deletePin(annotation: MKAnnotation, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["lat", annotation.coordinate.latitude, "lon", annotation.coordinate.longitude])
        
        let pins = getPins(fetchRequest, context: context).map { pins in return pins as! [Pin] }
        
        if pins != nil {
            for pin in pins! {
                context.deleteObject(pin)
            }
        }
    }
    
    static func getPins(request: NSFetchRequest, context: NSManagedObjectContext) -> [AnyObject]? {
        do {
            return try context.executeFetchRequest(request)
        } catch {
            fatalError("Fetch request fails!")
        }
    }
    
}
