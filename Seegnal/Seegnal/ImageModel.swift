//
//  ImageModel.swift
//  Seegnal
//
//  Created by Hoon on 2023/04/29.
//

import Foundation
import UIKit

// 이미지 전송 Encode용
struct ImageRequest: Codable {
    let image: Data
    
    init(image: UIImage) {
        self.image = image.jpegData(compressionQuality: 0.5)!
    }
    
    func getImage() -> UIImage? {
        return UIImage(data: self.image)
    }
}

// 이미지 전송 후 Decode용
struct ImageResponse: Codable {
    let text: String
}
