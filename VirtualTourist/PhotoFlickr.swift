//
//  Photo.swift
//  VirtualTourist
//
//  Created by Svyatoslav Reshetnikov on 06.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import ObjectMapper

class PhotoFlickr: Mappable {
    
    var farm: Int!
    var id: String!
    var isFamily: Bool!
    var isFriend: Bool!
    var isPublic: Bool!
    var owner: String!
    var secret: String!
    var server: String!
    var title: String!
    
    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        farm <- map[VirtualTouristClient.JSONResponseKeys.Farm]
        id <- map[VirtualTouristClient.JSONResponseKeys.ID]
        isFamily <- map[VirtualTouristClient.JSONResponseKeys.IsFamily]
        isFriend <- map[VirtualTouristClient.JSONResponseKeys.IsFriend]
        isPublic <- map[VirtualTouristClient.JSONResponseKeys.IsPublic]
        owner <- map[VirtualTouristClient.JSONResponseKeys.Owner]
        secret <- map[VirtualTouristClient.JSONResponseKeys.Secret]
        server <- map[VirtualTouristClient.JSONResponseKeys.Server]
        title <- map[VirtualTouristClient.JSONResponseKeys.Title]
    }
}
