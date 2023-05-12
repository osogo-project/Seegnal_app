//
//  Dispatchable.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public protocol Dispatchable {
    
    var components: URLComponents?{ get }
    
    var session: URLSessionProtocol { get }
    
    func dispatch(request: URLRequest,
                  completion: @escaping (Result<Data>, URLResponseProtocol?) -> ())
}
