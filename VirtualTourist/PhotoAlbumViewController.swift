//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit
import MapKit
import ImageLoader
import QuartzCore
import Foundation
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    var coordinate: CLLocationCoordinate2D!
    var images = [UIImage]()
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinate = CLLocationCoordinate2D(latitude: pin.lat!.doubleValue, longitude: pin.lon!.doubleValue)
        mapView.centerCoordinate = coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(PhotoAlbumViewController.photoSearch))
        navigationItem.rightBarButtonItem = updateButton
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray:["pin", pin])
        let photos = Photo.getPhotos(fetchRequest, context: context).map { photos in return photos as! [Photo] }
        
        if photos?.count > 0 {
            for photo in photos! {
                images.append(UIImage(data: photo.image!)!)
            }
        } else {
            photoSearch()
        }
    }
    
    func photoSearch() {
        print("photoSearch")
        // Clean
        images.removeAll()
        collectionView.reloadData()
        pin.cleatPhotos()
        
        // Update page number
        page += 1
        
        // Download new collection of images
        VirtualTouristClient.instance.photosSearch(coordinate.latitude, lon: coordinate.longitude, page: page, perPage: 21) { success, result, errorString in
            
            guard let photos = result?.photos?.photos else {
                return
            }
            
            for photo in photos {
                ImageLoader.load(Utils.instance.buildURLForPhoto(photo, size: "s")).completionHandler({ url, image, error, cacheType in
                    
                    if image != nil {
                        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                            self.images.append(image!)
                            Photo.savePhoto(UIImageJPEGRepresentation(image!, 1.0)!, pin: self.pin, context: self.context)
                            self.collectionView.reloadData()
                            
                            print("Saves")
                        }
                    }
                })
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.photo.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let showAction = UIAlertAction(title: "Show", style: .Default, handler: { alert -> Void in
            /*let fullPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FullPhotoViewController") as! FullPhotoViewController
            fullPhoto.photo = self.photos[indexPath.row]
            
            self.navigationController?.pushViewController(fullPhoto, animated: true)*/
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: { alert -> Void in
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert -> Void in
            
        })
        
        optionMenu.addAction(showAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}
