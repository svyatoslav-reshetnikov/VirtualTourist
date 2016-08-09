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

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinates: CLLocationCoordinate2D!
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerCoordinate = coordinates
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        VirtualTouristClient.instance.photosSearch(coordinates.latitude, lon: coordinates.longitude, perPage: "21") { success, result, errorString in
            
            guard let photos = result?.photos?.photos else {
                return
            }
            
            self.photos = photos
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.photo.load(Utils.instance.buildURLForPhoto(photos[indexPath.row], size: "s"))
        
        return cell
    }
}
