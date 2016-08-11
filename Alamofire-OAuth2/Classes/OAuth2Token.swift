//
//  OAuth2Token.swift
//  Pods
//
//  Created by Fabio Borella on 11/08/16.
//
//

import Foundation
import ObjectMapper

public class OAuth2Token: NSObject, Mappable, NSCoding {
    
    public internal(set) class var currentToken: OAuth2Token? {
        set {
            if newValue != nil {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "currentToken")
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("currentToken")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("currentToken") as? OAuth2Token
        }
    }
    
    public private(set) var accessToken: String!
    public private(set) var refreshToken: String?
    public private(set) var expirationDate: NSDate?
    
    var isExpired: Bool {
        if let expirationDate = expirationDate {
            return expirationDate.timeIntervalSinceNow < 0.0
        }
        return true
    }
    
    // Mappable
    
    public required init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        accessToken <- map["access_token"]
        refreshToken <- map["refresh_token"]
        expirationDate <- (map["expires_in"], DateTransform())
    }
    
    // Coding
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        accessToken = aDecoder.decodeObjectForKey("accessToken") as? String
        refreshToken = aDecoder.decodeObjectForKey("refreshToken") as? String
        expirationDate = aDecoder.decodeObjectForKey("expirationDate") as? NSDate
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accessToken, forKey: "accessToken")
        aCoder.encodeObject(refreshToken, forKey: "refreshToken")
        aCoder.encodeObject(expirationDate, forKey: "expirationDate")
    }
}