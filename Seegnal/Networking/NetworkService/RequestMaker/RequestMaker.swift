//
//  RequestMaker.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

import Foundation

public struct RequestMaker: RequestMakable {
    
    public init() {}
    
    public func makeRequest(url: URL,
                            method: HTTPMethod,
                            headers: [String : String],
                            body: Data?) -> URLRequest? {
        
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body
        
        switch method {
        case .get:
            return request
        case .post:
            request.httpMethod = method.rawValue
            return request
        case .patch:
            request.httpMethod = method.rawValue
            return request
        case .put:
            request.httpMethod = method.rawValue
            return request
        case .delete:
            request.httpMethod = method.rawValue
            return request
        }
    }

}
