//
//  APIClient.swift
//  Seegnal
//
//  Created by Hoon on 2023/04/29.
//

import Foundation
//
//class APIClient {
//
//    static let shared = APIClient()
//
//    private init() {}
//
//    let baseURL = "https://seegnal.pythonanywhere.com/api/v1/caption"
//
//    class Main {
//        func requestImage(_ imageRequest: ImageRequest, completion: @escaping (Result<ImageResponse, Error>) -> Void) {
//
//            guard let url = URL(string: APIClient.shared.baseURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            // HTTP 요청 헤더 필드를 변경하여 Multipart Form 형식으로 설정
//            let boundary = UUID().uuidString
//            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            // HTTP 요청 바디를 변경하여 Multipart Form 형식으로 설정
//            var httpBody = Data()
//            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
//            httpBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
//            httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//            httpBody.append(imageRequest.image)
//            httpBody.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//            request.httpBody = httpBody
//
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                print(data, response, error)
//                if let error = error {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                    return
//                }
//
//                guard let data = data else {
//                    DispatchQueue.main.async {
//                        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//                    }
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    let imageResponse = try decoder.decode(ImageResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(imageResponse))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//
//    let main = Main()
//}
//
