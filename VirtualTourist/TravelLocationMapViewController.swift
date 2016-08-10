//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 04.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit
import MapKit
import CoreData

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
        
        getPins()
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
            let coordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            mapView.addAnnotation(annotation)
            savePin(coordinates.latitude, lon: coordinates.longitude)
        }
    }
    
    // MARK: MKMapViewDelegate methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
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
            deletePin((view.annotation?.coordinate.latitude)!, lon: (view.annotation?.coordinate.longitude)!)
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
    
    // MARK: CoreData
    func savePin(lat: Double, lon: Double) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext:managedContext)
        let pin = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        pin.setValue(lat, forKey: "lat")
        pin.setValue(lon, forKey: "lon")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deletePin(lat: Double, lon: Double) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["lat", lat, "lon", lon])
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let pins = results as! [NSManagedObject]
            
            for pin in pins {
                managedContext.deleteObject(pin as NSManagedObject)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getPins() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let pins = results as! [NSManagedObject]
            
            for pin in pins {
                
                let lat = pin.valueForKey("lat") as! Double
                let lon = pin.valueForKey("lon") as! Double
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                mapView.addAnnotation(annotation)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
