//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 18/03/2023.
//

import Foundation
import DataAccess

public struct MovieCellModel: Hashable {
    public let movie: Movie
    
    // Hash
    public func hash(into hasher: inout Hasher) {
        hasher.combine(movie.imdbID)
    }
    
    public static func == (lhs: MovieCellModel, rhs: MovieCellModel) -> Bool {
        lhs.movie.imdbID == rhs.movie.imdbID
    }
}
