//
//  OAuth2Client.swift
//  Feedback
//
//  Created by Fabio Borella on 13/06/16.
//  Copyright © 2016 Feedback Technologies LLC. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public class OAuth2Client: NSObject {
    
    public static var clientID: String!
    public static var clientSecret: String!
    
    public static var baseURL: NSURL!
    public static var authenticationPath: String?
    
    static let sharedInstance = OAuth2Client()
    
    class func requestToken(username: String, password: String, completion: (OAuth2Token?, NSError?) -> ()) {
        Alamofire.request(OAuth2Router.RequestToken(username, password))
            .validate(statusCode: 200..<300)
            .responseObject(completionHandler: { (response: Response<OAuth2Token,NSError>) in
            switch response.result {
            case .Success(let token):
                OAuth2Token.currentToken = token
                completion(token, nil)
            case .Failure(let error):
                OAuth2Token.currentToken = nil
                completion(nil, error)
            }
        })
    }
    
    class func refreshToken(token: OAuth2Token, completion: () -> ()) {
        if let refreshToken = token.refreshToken {
            Alamofire.request(OAuth2Router.RefreshToken(refreshToken))
                .validate(statusCode: 200..<300)
                .responseObject(completionHandler: { (response: Response<OAuth2Token,NSError>) in
                switch response.result {
                case .Success(let token):
                    OAuth2Token.currentToken = token
                    completion()
                case .Failure(let _):
                    OAuth2Token.currentToken = nil
                    completion()
                }
            })
        }
    }
    
}

//public func request(URLRequest: URLRequestConvertible) -> Request {
//    // Check if the authorization token is expired or not
//    
//    if let token = OAuth2Token.currentToken {
//        
//    } else {
//        OAuth2Client.requestToken("", password: "", completion: { (token, error) in
//            
//        })
//    }
//    return Alamofire.Manager.sharedInstance.request(URLRequest.URLRequest)
//}
//
//extension Request {
//    
//    func requestOAuth2(URLRequest: URLRequestConvertible) -> Self {
//        
//        return self
//    }
//    
//    func validateOAuth2() -> Self {
//        return self
//    }
//    
//}
