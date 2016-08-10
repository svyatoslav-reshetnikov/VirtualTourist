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
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteText: UILabel!
    
    var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var editMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(TravelLocationMapViewController.addPinByLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        
        mapView.addGestureRecognizer(longPress)
        mapView.delegate = self
        
        editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action:#selector(TravelLocationMapViewController.changeEditMode(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action:#selector(TravelLocationMapViewController.changeEditMode(_:)))
        
        navigationItem.rightBarButtonItem = editButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeEditMode(sender: UIBarButtonItem) {
        
        switch sender {
        case editButton:
            navigationItem.rightBarButtonItem = doneButton
            setAlphaForDeleteInfo(1)
            break
        case doneButton:
            navigationItem.rightBarButtonItem = editButton
            setAlphaForDeleteInfo(0)
            break
        default:
            navigationItem.rightBarButtonItem = editButton
        }
        
        editMode = !editMode
    }
    
    func addPinByLongPress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == .Began && !editMode {
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
        
        if editMode {
            mapView.removeAnnotation(view.annotation!)
        } else {
            let photoAlbum = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
            photoAlbum.coordinates = view.annotation?.coordinate
        
            navigationController?.pushViewController(photoAlbum, animated: true)
        
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }
    
    func setAlphaForDeleteInfo(alpha: CGFloat) {
        deleteView.alpha = alpha
        deleteText.alpha = alpha
    }
}
