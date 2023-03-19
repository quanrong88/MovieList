//
//  Movies.swift
//  
//
//  Created by Tạ Minh Quân on 17/03/2023.
//

import Foundation

// MARK: - MoviesResponse
public struct MoviesResponse: Codable {
    public let search: [Movie]
    public let totalResults, response: String

    public enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Movie
public struct Movie: Codable {
    public let title, year, imdbID: String
    public let type: TypeEnum
    public let poster: String

    public enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

public enum TypeEnum: String, Codable {
    case movie = "movie"
}
