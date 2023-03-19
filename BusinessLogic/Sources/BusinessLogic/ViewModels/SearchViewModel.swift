//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 18/03/2023.
//

import Foundation
import DataAccess
import Combine

public class SearchViewModel {

    public enum Action {
        case search(word: String)
        case clear
    }
    
    @Published public var cellModels: [MovieCellModel] = []
    public let action = PassthroughSubject<Action, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
        action
            .throttle(for: .milliseconds(1000), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] action in
                self?.processAction(action)
            }
            .store(in: &subscriptions)
        
        self.repository.$movies
            .map { value in
                value.map{ MovieCellModel(movie: $0) }
            }
            .assign(to: \.cellModels, on: self)
            .store(in: &subscriptions)
    }
    
    private func processAction(_ action: Action) {
        switch action {
        case .search(let word):
            print("Request \(word)")
            repository.searchMoviesFromRemote(word: word)
        case .clear:
            repository.searchMoviesFromRemote(word: "")
        }
    }
}
