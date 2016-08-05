//
//  VirtualTouristFunctions.swift
//  VirtualTourist
//
//  Created by SVYAT on 05.08.16.
//  Copyright © 2016 HiT2B. All rights reserved.
//

import Foundation

extension VirtualTouristClient {

    func getAccessToken(completionHandler: (success: Bool, result: AnyObject?, errorString: String?) -> Void) {
        var parameters = [String:AnyObject]()
        parameters[VirtualTouristClient.RequestKeys.NoJsonCallback] = 1
        parameters[VirtualTouristClient.RequestKeys.Method] = VirtualTouristClient.Methods.GetAccessToken
        parameters[VirtualTouristClient.RequestKeys.Format] = VirtualTouristClient.RequestValues.JSON
        parameters[VirtualTouristClient.RequestKeys.ApiKey] = VirtualTouristClient.Constants.ApiKey
        parameters[VirtualTouristClient.RequestKeys.ApiSig] = Utils.instance.getApiSigFromParameters(parameters)
        
        let url = flickrUrlFromParameters(parameters, withPathExtension: "")
        
        let request = NSMutableURLRequest(URL: url)
        print(request.URL?.absoluteURL)
        
        taskForGETMethod(request) { results, error in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: error.localizedDescription)
            } else {
                completionHandler(success: true, result: results, errorString: "")
                /*if let resultsArray = results[OnTheMapClient.JSONResponseKeys.Results] as? NSArray {
                 var students = [StudentIndormation]()
                 for result in resultsArray {
                 let student = StudentIndormation(dictionary: result as! NSDictionary)
                 students.append(student)
                 }
                 
                 if students.count == 0 {
                 completionHandler(success: false, students: nil, errorString: "No students")
                 } else {
                 StudentCollection.instance.students = students
                 completionHandler(success: true, students: students, errorString: nil)
                 }
                 } else {
                 completionHandler(success: false, students: nil, errorString: "Could not find \(OnTheMapClient.JSONResponseKeys.Session) in \(results)")
                 }*/
            }
        }
    }
    
    func photosForLocation(lat: Double, lon: Double, accuracy: Double?, extras: Int?, per_page: Int?, page: Int?, completionHandler: (success: Bool, result: AnyObject?, errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters[VirtualTouristClient.RequestKeys.Method] = VirtualTouristClient.Methods.PhotosForLocation
        parameters[VirtualTouristClient.RequestKeys.Lat] = lat
        parameters[VirtualTouristClient.RequestKeys.Lon] = lon
        if accuracy != nil {
            parameters[VirtualTouristClient.RequestKeys.Accuracy] = accuracy
        }
        if extras != nil {
            parameters[VirtualTouristClient.RequestKeys.Extras] = extras
        }
        if per_page != nil {
            parameters[VirtualTouristClient.RequestKeys.PerPage] = per_page
        }
        if page != nil {
            parameters[VirtualTouristClient.RequestKeys.Page] = page
        }
        
        parameters[VirtualTouristClient.RequestKeys.Format] = VirtualTouristClient.RequestValues.JSON
        parameters[VirtualTouristClient.RequestKeys.ApiSig] = Utils.instance.getApiSigFromParameters(parameters)
        
        let url = flickrUrlFromParameters(parameters, withPathExtension: "")
        
        let request = NSMutableURLRequest(URL: url)
        
        taskForGETMethod(request) { results, error in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: error.localizedDescription)
            } else {
                completionHandler(success: true, result: results, errorString: "")
                /*if let resultsArray = results[OnTheMapClient.JSONResponseKeys.Results] as? NSArray {
                    var students = [StudentIndormation]()
                    for result in resultsArray {
                        let student = StudentIndormation(dictionary: result as! NSDictionary)
                        students.append(student)
                    }
                    
                    if students.count == 0 {
                        completionHandler(success: false, students: nil, errorString: "No students")
                    } else {
                        StudentCollection.instance.students = students
                        completionHandler(success: true, students: students, errorString: nil)
                    }
                } else {
                    completionHandler(success: false, students: nil, errorString: "Could not find \(OnTheMapClient.JSONResponseKeys.Session) in \(results)")
                }*/
            }
        }
    }
    
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
                /*if let resultsArray = results[OnTheMapClient.JSONResponseKeys.Results] as? NSArray {
                 var students = [StudentIndormation]()
                 for result in resultsArray {
                 let student = StudentIndormation(dictionary: result as! NSDictionary)
                 students.append(student)
                 }
                 
                 if students.count == 0 {
                 completionHandler(success: false, students: nil, errorString: "No students")
                 } else {
                 StudentCollection.instance.students = students
                 completionHandler(success: true, students: students, errorString: nil)
                 }
                 } else {
                 completionHandler(success: false, students: nil, errorString: "Could not find \(OnTheMapClient.JSONResponseKeys.Session) in \(results)")
                 }*/
            }
        }
    }
    
}