import XCTest
@testable import DataAccess
import Combine

final class DataAccessTests: XCTestCase {
    let apiService = APIService()
    
    var subscriptions = Set<AnyCancellable>()
    
    func testSearch() {
        let exp = expectation(description: "Load API")
        apiService.searchMovie(word: "Marvel", page: 1)
            .sink { _ in
                print("Completed")
                exp.fulfill()
            } receiveValue: { value in
                print("Total \(value.search.count)")
                print(value)
            }
            .store(in: &subscriptions)
        waitForExpectations(timeout: 5)
    }
    
    func testRepository() {
        let exp = expectation(description: "Load API")
        let repository = Repository(apiService: apiService)
        repository.searchMoviesFromRemote(word: "Marvel")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print(repository.currentPage)
            repository.searchMoviesFromRemote(word: "Marvel")
        }
        
        repository.$movies
            .sink { _ in
                exp.fulfill()
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
            
        waitForExpectations(timeout: 5)
    }
}
