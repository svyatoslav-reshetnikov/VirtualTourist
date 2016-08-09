//
//  Utils.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation

class Utils {
    
    static let instance = Utils()
    
    func md5(string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    func getApiSigFromParameters(parameters: [String : AnyObject]) -> String {
        let sortedArray = parameters.sort { $0.0 < $1.0 }
        
        var str = VirtualTouristClient.Constants.ApiSecret
        for object in sortedArray {
            str += object.0 + String(object.1)
        }
        
        return md5(str)
    }
    
    /*
     size is a parameter from Flickr:
     
     s	small square 75x75
     q	large square 150x150
     t	thumbnail, 100 on longest side
     m	small, 240 on longest side
     n	small, 320 on longest side
     -	medium, 500 on longest side
     z	medium 640, 640 on longest side
     c	medium 800, 800 on longest side†
     b	large, 1024 on longest side*
     h	large 1600, 1600 on longest side†
     k	large 2048, 2048 on longest side†
     o	original image, either a jpg, gif or png, depending on source format
     */
    func buildURLForPhoto(photo: PhotoFlickr, size: String) -> String {
        var url = "https://farm" + String(photo.farm) + ".staticflickr.com/"
        url += String(photo.server) + "/"
        url += photo.id + "_" + photo.secret + "_" + size + ".jpg"
        
        return url
    }
}