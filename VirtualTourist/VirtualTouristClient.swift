//
//  VirtualTouristClient.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation

// MARK: - VirtualTouristClient: NSObject

class VirtualTouristClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    var objectID: String? = nil
    
    // MARK: Shared Instance
    static let instance = VirtualTouristClient()
    
    // MARK: GET
    
    func taskForGETMethod(request: NSMutableURLRequest, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataFromFlickrWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(request: NSMutableURLRequest, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let response = response as! NSHTTPURLResponse
                if response.statusCode == 403 {
                    sendError("Invalid credentials!")
                } else {
                    sendError("Your request returned a status code \(response.statusCode)!")
                }
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataFromFlickrWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    
    private func convertDataFromFlickrWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // Create an URL from parameters
    private func createURLComponentWithParameters(parameters: [String:AnyObject]) -> NSURLComponents {
        
        let components = NSURLComponents()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            var queryItems = components.queryItems ?? [NSURLQueryItem]()
            queryItems.append(queryItem)
        }
        
        return components
    }
    
    func flickrUrlFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = createURLComponentWithParameters(parameters)
        
        components.scheme = VirtualTouristClient.Constants.HTTPSScheme
        components.host = VirtualTouristClient.Constants.FlickrHost
        components.path = VirtualTouristClient.Constants.FlickrPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    /*func udacityUrlFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = createURLComponentWithParameters(parameters)
        
        components.scheme = VirtualTouristClient.Constants.HTTPSScheme
        components.host = VirtualTouristClient.Constants.UdacityHost
        components.path = VirtualTouristClient.Constants.UdacityPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    func parseUrlFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = createURLComponentWithParameters(parameters)
        
        components.scheme = VirtualTouristClient.Constants.HTTPSScheme
        components.host = VirtualTouristClient.Constants.ParseHost
        components.path = VirtualTouristClient.Constants.ParsePath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }*/
}
