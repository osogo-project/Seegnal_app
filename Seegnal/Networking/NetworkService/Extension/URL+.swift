//
//  URL+.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/12.
//

import Foundation

extension URL {
    func asUrlWithoutEncoding() -> URL? {
        guard let stringUrl = self.absoluteString.removingPercentEncoding else {
            return nil
        }
        return URL(string: stringUrl)
    }
    
}
