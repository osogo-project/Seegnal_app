//
//  URLSessionProtocol.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void) -> URLSessionTaskProtocol
    
    
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void)
        -> URLSessionTaskProtocol
}

extension URLSession: URLSessionProtocol {

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void) -> URLSessionTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionTaskProtocol
    }

    public func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponseProtocol?, Error?) -> Void)
        -> URLSessionTaskProtocol {

            return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as  URLSessionTaskProtocol
    }
}

extension URLSessionTask: URLSessionTaskProtocol {
    
}
