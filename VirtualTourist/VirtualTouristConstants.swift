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
        
        // MARK: Udacity keys
        
        // Session
        static let Session = "session"
        static let SessionID = "id"
        
        // Account
        static let Account = "account"
        static let Key = "key"
        
        // User
        static let User = "user"
        static let UdacityFirstName = "first_name"
        static let UdacityLastName = "last_name"
        
        // MARK: Parse keys
        
        // Students information
        static let Results = "results"
        
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        
        // Post student
        static let ObjectID = "objectId"
    }
}
