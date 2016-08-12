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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var pin: Pin!
    var coordinate: CLLocationCoordinate2D!
    var images = [UIImage]()
    var photos = [Photo]()
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
                self.photos.append(photo)
            }
        } else {
            photoSearch()
        }
    }
    
    func photoSearch() {
        
        indicator.startAnimating()
        
        // Clean
        images.removeAll()
        collectionView.reloadData()
        pin.cleatPhotos()
        
        // Update page number
        page += 1
        
        // Download new collection of images
        VirtualTouristClient.instance.photosSearch(coordinate.latitude, lon: coordinate.longitude, page: page, perPage: 21) { success, result, errorString in
            
            // UI related code
            dispatch_async(dispatch_get_main_queue()){
                self.indicator.stopAnimating()
            }
            
            guard let downloadedImages = result?.photos?.photos else {
                return
            }
            
            for image in downloadedImages {
                let imgURL = NSURL(string: Utils.instance.buildURLForPhoto(image, size: "s"))
                let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, downloadError in
                    if data != nil {
                        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                            self.images.append(UIImage(data: data!)!)
                            let photo = Photo.savePhoto(data!, pin: self.pin, context: self.context)
                            self.photos.append(photo)
                            self.collectionView.reloadData()
                        }
                    }
                }
                task.resume()
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
        
        images.removeAtIndex(indexPath.row)
        Photo.deletePhoto(photos[indexPath.row], context: context)
        
        collectionView.reloadData()
    }
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}
