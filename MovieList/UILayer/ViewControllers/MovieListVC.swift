//
//  MovieListVC.swift
//  
//
//  Created by Tạ Minh Quân on 19/03/2023.
//

import UIKit
import BusinessLogic
import Combine

class MovieListVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyIcon: UIImageView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieCellModel>
    
    enum Section {
      case main
    }
    
    var subscriptions = [AnyCancellable]()
    private lazy var dataSource = makeDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    
    let viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: "MovieListVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie List"
        setupCollectionView()
        bindingViewModel()
        setUpSearchController()
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
                cell.cellModel = cellModel
                return cell
            })
        
        return dataSource
    }
    
    func applySnapshot(cellModels: [MovieCellModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([Section.main])
        snapshot.appendItems(cellModels)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")
        collectionView.delegate = self
        let screenWidth = UIScreen.main.bounds.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        let itemWidth = screenWidth / 2 - 20
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
    }
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func bindingViewModel() {
        viewModel.$cellModels
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.applySnapshot(cellModels: value)
                self.emptyIcon.isHidden = !value.isEmpty
            }
            .store(in: &subscriptions)
    }
}

extension MovieListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let word = searchController.searchBar.text else { return }
        print("Search \(word)")
        viewModel.action.send(.search(word: word))
    }
}

extension MovieListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataSource.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 3, let word = searchController.searchBar.text, !word.isEmpty {
            viewModel.action.send(.search(word: word))
        }
    }
}
