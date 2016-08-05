//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 04.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VirtualTouristClient.instance.photosSearch(55.754884, lon: 37.620763) { success, result, errorString in
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

