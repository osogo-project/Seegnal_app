//
//  URLResponseProtocol.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public protocol URLResponseProtocol {
    var isSuccess: Bool { get }
    func isMimeType(type: MimeType) -> Bool
    var url: URL? { get }
}

extension URLResponse {
    
    public var isSuccess: Bool {
        guard let response = self as? HTTPURLResponse else { return false }
        return (200...299).contains(response.statusCode)
    }
    
    public func isMimeType(type: MimeType) -> Bool {
        guard let mimeType = self.mimeType, mimeType == type.rawValue else {
            return false
        }
        return true
    }
}

extension URLResponse: URLResponseProtocol {
    
}
