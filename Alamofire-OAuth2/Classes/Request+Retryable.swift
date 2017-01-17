//
//  Request+OAuth2.swift
//  Pods
//
//  Created by Fabio Borella on 17/01/17.
//
//

import Foundation
import Alamofire
import p2_OAuth2

extension Request {
    
    internal func authenticateOAuth2(retryBlock: (Void) -> Void) -> Self {
        
        let retryOperation = NSBlockOperation {
            if let response = self.response {
                if response.statusCode == 401 {
                    
                    retryBlock()
                    
                    self.delegate.queue.cancelAllOperations()
                    self.delegate.queue.suspended = false
                }
            }
        }
        
        // Make the authentication check operation the first
        // to be exeecuted before all other responses
        
        let operations = delegate.queue.operations
        for (i, operation) in operations.enumerate() {
            if i == 0 {
                operation.addDependency(retryOperation)
            } else {
                operation.addDependency(operations[i-1])
            }
        }
        
        // Add the authentication check response
        
        delegate.queue.addOperation(retryOperation)
        
        return self
    }
    
}

