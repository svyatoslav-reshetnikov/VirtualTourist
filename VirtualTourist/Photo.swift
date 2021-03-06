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

    static func savePhoto(image: NSData, pin: Pin, context: NSManagedObjectContext) -> Photo {
        if let ent = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context) {
            let photo = Photo(entity: ent, insertIntoManagedObjectContext: context)
            photo.image = image
            photo.pin = pin
            
            do {
                try context.save()
            } catch let error as NSError  {
                fatalError("Could not save \(error), \(error.userInfo)")
            }
            
            return photo
        } else {
            fatalError("Unable to find entity name!")
        }
    }
    
    static func deletePhotosInPin(pin: Pin, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray:["pin", pin])
        
        let photos = getPhotos(fetchRequest, context: context).map { photos in return photos as! [Photo] }
        
        if photos != nil {
            for photo in photos! {
                context.deleteObject(photo)
                
                do {
                    try context.save()
                } catch let error as NSError  {
                    fatalError("Could not save \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    static func deletePhoto(photo: Photo, context: NSManagedObjectContext) {
        context.deleteObject(photo)
        
        do {
            try context.save()
        } catch let error as NSError  {
            fatalError("Could not save \(error), \(error.userInfo)")
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
