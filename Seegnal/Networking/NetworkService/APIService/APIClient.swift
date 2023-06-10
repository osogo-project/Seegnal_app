//
//  APIClient.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
    // V1
    let baseURL = "https://seegnal.pythonanywhere.com/api/v2/caption_kr"
    let ocrURL = "https://oshmos.pythonanywhere.com/api/v2/ocr_kr"
    
    class ImageCaptioning {
        
        let requestMaker = RequestMaker()
        var jsonParser = JsonParser()
        let dispatcher = Dispatcher(session: URLSession.shared)

        func requestImage(_ imageRequest: ImageRequest,
                          completion: @escaping (Result<ImageResponse>) -> Void) {
            
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
                    guard let text = self.jsonParser.extractDecodedJsonData(decodeType: ImageResponse.self, binaryData: data) else {
                        completion(.failure(APIError.jsonParsingFailure))
                        return
                    }
                    completion(.success(text))
                }
                
            }
        }
    }
    
    class OCR {
        let requestMaker = RequestMaker()
        var jsonParser = JsonParser()
        let dispatcher = Dispatcher(session: URLSession.shared)

        func requestImage(_ imageRequest: ImageRequest,
                          completion: @escaping (Result<ImageResponse>) -> Void) {
            
            guard let url = URL(string: APIClient.shared.ocrURL) else { return }
            
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
                    guard let text = self.jsonParser.extractDecodedJsonData(decodeType: ImageResponse.self, binaryData: data) else {
                        completion(.failure(APIError.jsonParsingFailure))
                        return
                    }
                    completion(.success(text))
                }
                
            }
        }
    }
    
    let imageCaptioning = ImageCaptioning()
    let ocr = OCR()
}
