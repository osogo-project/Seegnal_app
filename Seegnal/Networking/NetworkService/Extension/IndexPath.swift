//
//  IndexPath.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/31.
//

import Foundation

extension IndexPath {
    var next: IndexPath? {
        return item < Int.max ? IndexPath(item: item + 1, section: section) : nil
    }
    
    var previous: IndexPath? {
        return item > 0 ? IndexPath(item: item - 1, section: section) : nil
    }
}
