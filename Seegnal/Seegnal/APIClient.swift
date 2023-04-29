//
//  APIClient.swift
//  Seegnal
//
//  Created by Hoon on 2023/04/29.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    let baseURL = "http://127.0.0.1:8000/"
    
    class Main {
        func requestImage(_ imageRequest: ImageRequest, completion: @escaping (Result<ImageResponse, Error>) -> Void) {
            
            guard let url = URL(string: APIClient.shared.baseURL + "api/v1/caption") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(imageRequest)
                request.httpBody = jsonData
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let imageResponse = try decoder.decode(ImageResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(imageResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
        
    let main = Main()
}

