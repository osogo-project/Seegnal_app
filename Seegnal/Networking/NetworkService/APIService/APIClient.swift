//
//  APIClient.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
    let baseURL = "https://seegnal.pythonanywhere.com/api/v1/caption"
    
    private init() {}
    
    
    class ImageCaptioning {
        
        let requestMaker: RequestMakable
        var jsonParser = JsonParser()
        let dispatcher: Dispatchable
        
        public init(dispatcher: Dispatchable, requestMaker: RequestMakable) {
            self.dispatcher = dispatcher
            self.requestMaker = requestMaker
        }
        
        func requestImage(_ imageRequest: ImageRequest, completion: @escaping (Result<Data>) -> Void) {
            
            guard let url = URL(string: APIClient.shared.baseURL) else { return }
            
            // HTTP 요청 헤더필드 변경 : Multipart Form
            
            let boundary = UUID().uuidString
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageRequest.image)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            
            guard let request = requestMaker.makeRequest(url: url,
                                                         method: .post,
                                                         headers: ["Content-Type" : "multipart/form-data; boundary=\(boundary)"],
                                                         body: body) else {
                completion(.failure(APIError.requestFailed))
                return
            }
            
            dispatcher.dispatch(request: request) { (result, response) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    completion(.success(data))
                }
                
            }
        }
    }
    
    let imageCaptioning = ImageCaptioning()
}
