//
//  FullPhotoViewController.swift
//  VirtualTourist
//
//  Created by SVYAT on 09.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import UIKit
import ImageLoader

class FullPhotoViewController: UIViewController {

    @IBOutlet weak var fullPhoto: UIImageView!
    var photo: PhotoFlickr!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoUrl = Utils.instance.buildURLForPhoto(photo, size: "h")
        print(photoUrl)
        fullPhoto.load(photoUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}