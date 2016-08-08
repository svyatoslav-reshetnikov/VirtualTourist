//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VirtualTouristClient.instance.photosSearch(55.754884, lon: 37.620763) { success, result, errorString in
            
            guard let photos = result?.photos?.photos else {
                return
            }
            
            for photo in photos {
                print(photo.isPublic)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
