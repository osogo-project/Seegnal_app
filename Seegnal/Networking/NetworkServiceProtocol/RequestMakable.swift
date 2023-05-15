//
//  RequestMakable.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public protocol RequestMakable {
    
    func makeRequest(url: URL, method: HTTPMethod, headers: [String: String],
                     body: Data?) -> URLRequest?
    
}
