//
//  Dispatcher.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public enum Result<Value> {
    case failure(Error)
    case success(Value)
}

public struct Dispatcher: Dispatchable {
    
    public var session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
    
    /// 실제 네트워크 통신을 시작하는 메서드입니다.
    ///
    /// - Parameters:
    ///   - request: dataTask() 메서드의 인자로 들어갈 URLRequest를 인자로 받습니다.
    ///   - completion: 메서드가 리턴된 이후에 호출되는 클로저입니다.
    /// - Returns: Result enum 타입으로 값을 감싸서 연관 값으로 전달합니다.
    ///            Result<Data>, URLResponse? 로 전달되는 이유는 어떤 데이터는 HTTPHeader에
    ///            또 어떤 데이터는 body에만 전달되는 경우가 있기 때문입니다.
    
    public func dispatch(request: URLRequest,
                         completion: @escaping(Result<Data>, URLResponseProtocol?) -> ()) {
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error), response)
                }
            }
            
            guard response?.isSuccess ?? false else {
                completion(.failure(error ?? APIError.responseUnsuccessful), response)
                return
            }
            
            guard let data = data else {
                completion(.failure(error ?? APIError.invalidData), nil)
                return
            }
            completion(.success(data), response)
        }
        task.resume()
    }
    
    
}
