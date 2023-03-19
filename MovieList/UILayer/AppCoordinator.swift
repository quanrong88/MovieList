//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 19/03/2023.
//

import Foundation
import BusinessLogic
import DataAccess
import UIKit

public class AppCoordinator {
    let repository: Repository
    let apiService: APIService
    
    public var window: UIWindow
    let navigationController: UINavigationController
    
    public init(window: UIWindow) {
        self.window = window
        self.apiService = APIService()
        self.repository = Repository(apiService: apiService)
        
        let viewModel = SearchViewModel(repository: repository)
        let viewController = MovieListVC(viewModel: viewModel)
        
        self.navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .purple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    public func start() {
        window.rootViewController = navigationController
    }
    
    public func finish() {
        
    }
}
