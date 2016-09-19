//
//  OAuth2Router.swift
//  Pods
//
//  Created by Fabio Borella on 11/08/16.
//
//

import Foundation
import Alamofire

internal enum OAuth2Router: URLRequestConvertible {
    
    // MARK: Authorization
    
    /// Endpoint to request an OAuth2 token
    case RequestToken(String, String)
    /// Endpoint to refresh a previous access token
    case RefreshToken(String)
    
    private var baseURL: NSURL {
        return OAuth2Manager.baseURL
    }
    
    private var method: Alamofire.Method {
        return .POST
    }
    
    private var path: String? {
        return OAuth2Manager.authenticationPath
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .RequestToken(let username, let password):
            return [
                "grant_type" : "password",
                "username" : username,
                "password" : password,
                "client_id" : OAuth2Manager.clientID,
                "client_secret" : OAuth2Manager.clientSecret
            ]
        case .RefreshToken(let token):
            return [
                "grant_type" : "refresh_token",
                "refresh_token" : token,
                "client_id" : OAuth2Manager.clientID,
                "client_secret" : OAuth2Manager.clientSecret
            ]
        }
    }
    
    // MARK: URL generation
    
    var URLRequest: NSMutableURLRequest {
        
        var URL = baseURL
        if let path = path {
            URL = URL.URLByAppendingPathComponent(path)
        }
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        
        // Configure authorization
        
        if let token = OAuth2Token.currentToken {
            request.setValue("Bearer \(token.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        // Configure parameters
        
        return Alamofire.ParameterEncoding.JSON.encode(request, parameters: parameters).0
    }
    
}