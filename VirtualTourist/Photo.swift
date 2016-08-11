//
//  Photo.swift
//  VirtualTourist
//
//  Created by SVYAT on 10.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {

    static func savePhoto(image: NSData, pin: Pin, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context) {
            let photo = Photo(entity: ent, insertIntoManagedObjectContext: context)
            photo.image = image
            photo.pin = pin
            
            do {
                try context.save()
            } catch let error as NSError  {
                fatalError("Could not save \(error), \(error.userInfo)")
            }
        } else {
            fatalError("Unable to find entity name!")
        }
    }
    
    static func deletePhoto(pin: Pin, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["pin", pin])
        
        let pins = getPhotos(fetchRequest, context: context).map { pins in return pins as! [Photo] }
        
        if pins != nil {
            for pin in pins! {
                context.deleteObject(pin)
            }
        }
    }
    
    static func getPhotos(request: NSFetchRequest, context: NSManagedObjectContext) -> [AnyObject]? {
        do {
            return try context.executeFetchRequest(request)
        } catch {
            fatalError("Fetch request fails!")
        }
    }

}
