//
//  VirtualTouristFunctions.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation
import ObjectMapper

extension VirtualTouristClient {
    
    func photosSearch(lat: Double, lon: Double, page: Int, perPage: Int, completionHandler: (success: Bool, result: PhotosSearchResponse?, errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters[VirtualTouristClient.RequestKeys.Method] = VirtualTouristClient.Methods.PhotosSearch
        parameters[VirtualTouristClient.RequestKeys.Lat] = lat
        parameters[VirtualTouristClient.RequestKeys.Lon] = lon
        parameters[VirtualTouristClient.RequestKeys.Page] = page
        parameters[VirtualTouristClient.RequestKeys.PerPage] = perPage
        
        parameters[VirtualTouristClient.RequestKeys.Format] = VirtualTouristClient.RequestValues.JSON
        parameters[VirtualTouristClient.RequestKeys.NoJsonCallback] = 1
        parameters[VirtualTouristClient.RequestKeys.ApiKey] = VirtualTouristClient.Constants.ApiKey
        parameters[VirtualTouristClient.RequestKeys.ApiSig] = Utils.instance.getApiSigFromParameters(parameters)
        
        let url = flickrUrlFromParameters(parameters, withPathExtension: "")
        
        let request = NSMutableURLRequest(URL: url)
        
        taskForGETMethod(request) { result, error in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: error.localizedDescription)
            } else {
                let photoResponse = Mapper<PhotosSearchResponse>().map(result)!
                completionHandler(success: true, result: photoResponse, errorString: "")
            }
        }
    }
    
}