//
//  VirtualTouristConstants.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

extension VirtualTouristClient {
    
    // MARK: Constants
    struct Constants {
        
        static let HTTPSScheme = "https"
        static let ApplicationJSON = "application/json"
        
        // MARK: Flickr keys
        static let ApiKey = "f83594563c4f9d072ef18ec620516221"
        static let ApiSecret = "3bb79026132399ea"
        
        // MARK: Flickr URLs
        static let FlickrHost = "api.flickr.com"
        static let FlickrPath = "/services/rest/"
    }
    
    // MARK: Methods
    struct Methods {
        static let PhotosSearch = "flickr.photos.search"
    }
    
    struct RequestKeys {
        // All requests
        static let Method = "method"
        static let Format = "format"
        static let ApiKey = "api_key"
        static let AuthToken = "auth_token"
        static let ApiSig = "api_sig"
        static let NoJsonCallback = "nojsoncallback"
        
        // PhotosForLocation
        static let Lat = "lat"
        static let Lon = "lon"
    }
    
    struct RequestValues {
        static let JSON = "json"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Stat = "stat"
        
        // PhotosSearch
        static let Photos = "photos"
        
        static let Page = "page"
        static let Pages = "pages"
        static let Perpage = "perpage"
        static let Photo = "photo"
        static let Total = "total"
        
        // Photo from photos array
        static let Farm = "farm"
        static let ID = "id"
        static let IsFamily = "isfamily"
        static let IsFriend = "isfriend"
        static let IsPublic = "ispublic"
        static let Owner = "owner"
        static let Secret = "secret"
        static let Server = "server"
        static let Title = "title"
    }
}
