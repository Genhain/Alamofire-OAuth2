//
//  OAuth2+Retryable.swift
//  Pods
//
//  Created by Fabio Borella on 17/01/17.
//
//

import Foundation
import Alamofire
import p2_OAuth2

extension OAuth2 {
    
    public func retryRequest(requestBlock: (OAuth2) -> Request) {
        // Get the original value for startRequestsImmediately
        
        let shouldStartRequestsImmediately = Alamofire.Manager.sharedInstance.startRequestsImmediately
        
        // Prevent Manager to start requests immediately, we need this to manipulate the request before starting it
        
        Alamofire.Manager.sharedInstance.startRequestsImmediately = false
        
        // Get the request
        
        let request = requestBlock(self)
        
        // Restore the original value for startRequestsImmediately
        
        Alamofire.Manager.sharedInstance.startRequestsImmediately = shouldStartRequestsImmediately
        
        // Add the OAuth2 authentication check passing the retryable request block
        
        let retryBlock = {
            // Should try to authenticate or refresh
            self.forgetTokens()
            self.onAuthorize = { p in
                requestBlock(self)
            }
            self.authorize()
        }
        
        request.authenticateOAuth2(retryBlock)
        
        // If the Manager has been configured to start requests immediately, than we manually start it
        
        if shouldStartRequestsImmediately {
            request.resume()
        }
    }
    
    public func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil)
        -> Request
    {
        var hdrs = headers ?? [:]
        if let token = accessToken {
            hdrs["Authorization"] = "Bearer \(token)"
        }
        return Alamofire.request(method,
                                 URLString,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: headers)
    }
    
    public func request(URLRequest: URLRequestConvertible, shouldForgetTokens: Bool = true) -> Request {
        let URLRequest = URLRequest.URLRequest
        if let token = accessToken {
            URLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return Alamofire.Manager.sharedInstance.request(URLRequest)
    }
    
}
