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
}