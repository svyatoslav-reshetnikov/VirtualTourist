//
//  VirtualTouristFunctions.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation

extension VirtualTouristClient {
    
    func photosSearch(lat: Double, lon: Double, completionHandler: (success: Bool, result: AnyObject?, errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters[VirtualTouristClient.RequestKeys.Method] = VirtualTouristClient.Methods.PhotosSearch
        parameters[VirtualTouristClient.RequestKeys.Lat] = lat
        parameters[VirtualTouristClient.RequestKeys.Lon] = lon
        
        parameters[VirtualTouristClient.RequestKeys.Format] = VirtualTouristClient.RequestValues.JSON
        parameters[VirtualTouristClient.RequestKeys.NoJsonCallback] = 1
        parameters[VirtualTouristClient.RequestKeys.ApiKey] = VirtualTouristClient.Constants.ApiKey
        parameters[VirtualTouristClient.RequestKeys.ApiSig] = Utils.instance.getApiSigFromParameters(parameters)
        
        let url = flickrUrlFromParameters(parameters, withPathExtension: "")
        
        let request = NSMutableURLRequest(URL: url)
        
        taskForGETMethod(request) { results, error in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: error.localizedDescription)
            } else {
                completionHandler(success: true, result: results, errorString: "")
            }
        }
    }
    
}