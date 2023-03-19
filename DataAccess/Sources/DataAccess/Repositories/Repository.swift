//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 18/03/2023.
//

import Foundation
import Combine

public class Repository {
    public let apiService: APIService
    public var subscriptions = Set<AnyCancellable>()
    public let repositoryQueue = DispatchQueue(label: "Repository", qos: .default, attributes: .concurrent)
    
    @Published public var movies: [Movie]
    var currentPage = 1
    var loading = 0
    var currentWord = ""
    var maxPage = 1
    
    public init(apiService: APIService) {
        self.apiService = apiService
        self.movies = []
    }
    
    public func searchMoviesFromRemote(word: String) {
        if word != currentWord {
            currentPage = 1
            maxPage = 1
            currentWord = word
        } else if word.isEmpty {
            currentPage = 1
            maxPage = 1
            currentWord = ""
            movies.removeAll()
            return
        } else {
            if currentPage > maxPage {
                return
            }
            if loading == currentPage {
                return
            }
            
        }
        loading = currentPage
        apiService.searchMovie(word: word, page: currentPage)
            .receive(on: repositoryQueue)
            .sink(receiveCompletion: { error in
                print(error)
                self.loading = 0
                if self.currentPage == 1 {
                    self.movies.removeAll()
                }
            }, receiveValue: { value in
                if self.currentPage == 1 {
                    self.movies.removeAll()
                }
                self.movies.append(contentsOf: value.search)
                self.currentPage += 1
                self.maxPage = Int(ceil(Double(value.totalResults)! / 10))
                self.loading = 0
            })
            .store(in: &subscriptions)
    }
}
