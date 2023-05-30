//
//  ReplicateModel.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/17.
//

import Foundation
import Replicate

enum StableDiffusion: Predictable {
    
    static var modelID = "stability-ai/stable-diffusion"
    static let versionID = "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf"

    struct Input: Codable {
      let prompt: String
    }

    typealias Output = [URL]
}
