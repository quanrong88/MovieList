//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 17/03/2023.
//

import Foundation

enum EndPoint {
    case search(word: String, page: Int)
    
    var url: URL? {
        switch self {
        case .search(let word, let page):
            return URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&s=\(word)&type=movie&page=\(page)")
        }
    }
}
