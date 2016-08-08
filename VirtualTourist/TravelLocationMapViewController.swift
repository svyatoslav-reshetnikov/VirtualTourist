//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 04.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(TravelLocationMapViewController.addPinByLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        
        mapView.addGestureRecognizer(longPress)
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addPinByLongPress(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: MKMapViewDelegate methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("pinAnnotation") as? MKPinAnnotationView
        if pin ==  nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotation")
        } else {
            pin?.annotation = annotation
        }
        
        pin!.animatesDrop = true
        
        return pin
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        let photoAlbum = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        photoAlbum.coordinates = view.annotation?.coordinate
        
        navigationController?.pushViewController(photoAlbum, animated: true)
        
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
