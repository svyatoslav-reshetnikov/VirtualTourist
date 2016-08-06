//
//  Photos.swift
//  VirtualTourist
//
//  Created by Svyatoslav Reshetnikov on 06.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import ObjectMapper

class Photos: Mappable {
    
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photos = [Photo]()
    
    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        page <- map[VirtualTouristClient.JSONResponseKeys.Page]
        pages <- map[VirtualTouristClient.JSONResponseKeys.Pages]
        perpage <- map[VirtualTouristClient.JSONResponseKeys.Perpage]
        total <- map[VirtualTouristClient.JSONResponseKeys.Total]
        photos <- map[VirtualTouristClient.JSONResponseKeys.Photo]
    }
}
