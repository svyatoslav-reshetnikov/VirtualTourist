//
//  PhotosSearchResponse.swift
//  VirtualTourist
//
//  Created by Svyatoslav Reshetnikov on 06.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import ObjectMapper

class PhotosSearchResponse: Mappable {
    
    var stat: String?
    var photos: Photos?
    
    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        stat <- map[VirtualTouristClient.JSONResponseKeys.Stat]
        photos <- map[VirtualTouristClient.JSONResponseKeys.Photos]
    }
}
