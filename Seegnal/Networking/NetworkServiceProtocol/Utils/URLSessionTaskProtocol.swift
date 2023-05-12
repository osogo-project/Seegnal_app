//
//  URLSessionTaskProtocol.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public protocol URLSessionTaskProtocol {
    
    var state: URLSessionTask.State { get }
    
    func resume()
    func cancel()
}
