//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 17/03/2023.
//

import Foundation
import Combine

public class APIService {
    public init() {}
    
    let decoder = JSONDecoder()
    let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    public enum APIError: Error {
       case error(String)
       case errorURL
       case invalidResponse
       case errorParsing
       case unknown
       
       var localizedDescription: String {
         switch self {
         case .error(let string):
           return string
         case .errorURL:
           return "URL String is error."
         case .invalidResponse:
           return "Invalid response"
         case .errorParsing:
           return "Failed parsing response from server"
         case .unknown:
           return "An unknown error occurred"
         }
       }
     }
    
    func fetchData<Response: Decodable>(url: URL) -> AnyPublisher<Response, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .subscribe(on: apiQueue)
            .tryMap { output in
                      guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.invalidResponse
                      }
                      return output.data
                  }
                  .decode(type: Response.self, decoder: decoder)
                  .mapError { error -> APIError in
                        switch error {
                        case is URLError:
                          return .errorURL
                        case is DecodingError:
                          return .errorParsing
                        default:
                          return error as? APIError ?? .unknown
                        }
                      }
                  .eraseToAnyPublisher()
    }
    
    public func searchMovie(word: String, page: Int) -> AnyPublisher<MoviesResponse, APIError> {
        guard let url = EndPoint.search(word: word, page: page).url else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }
        return fetchData(url: url)
    }
}
