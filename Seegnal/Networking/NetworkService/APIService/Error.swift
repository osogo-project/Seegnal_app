//
//  Error.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

public enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case urlFailure
    case waitRequest
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .urlFailure: return "url Failure, app is gonna be off"
        case .waitRequest: return "Request is waiting"
        }
    }
}
