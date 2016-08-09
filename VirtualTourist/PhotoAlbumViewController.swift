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
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerCoordinate = coordinates
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(PhotoAlbumViewController.photoSearch))
        navigationItem.rightBarButtonItem = updateButton
        
        photoSearch()
    }
    
    func photoSearch() {
        
        page += 1
        
        // Clean collectionView
        photos = [Photo]()
        self.collectionView.reloadData()
        
        VirtualTouristClient.instance.photosSearch(coordinates.latitude, lon: coordinates.longitude, page: page, perPage: 21) { success, result, errorString in
            
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
    
    // MARK: UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.photo.load(Utils.instance.buildURLForPhoto(photos[indexPath.row], size: "s"))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: { alert -> Void in
            
        })
        
        let viewAction = UIAlertAction(title: "View", style: .Default, handler: { alert -> Void in
            let fullPhoto = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FullPhotoViewController") as! FullPhotoViewController
            fullPhoto.photo = self.photos[indexPath.row]
            
            self.navigationController?.pushViewController(fullPhoto, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(viewAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
}
