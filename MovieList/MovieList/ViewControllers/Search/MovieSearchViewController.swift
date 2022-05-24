//
//  MovieSearchViewController.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 24.05.2022.
//

import Foundation
import UIKit
import SwiftUI

enum SectionSearch {
    case foundMovies
}

typealias LayoutSectionMovieTuple = (layout: SectionSearch, items: [MovieSearch])

class MovieSearchViewController: UIViewController {
    var store: [LayoutSectionMovieTuple] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<SectionSearch, MovieSearch>!
    var listCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, MovieSearch>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setCollectionView()
        setupCellAndSupplementaryRegistrations()
        setSearchViewController()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupCellAndSupplementaryRegistrations() {
        listCellRegistration = .init(handler: { (cell, indexPath, item) in
            cell.setup(movie: item)
        })
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sectionIdentifier {
            case .foundMovies:
                var listConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
//                listConfig.headerMode = .supplementary
//                listConfig.footerMode = .supplementary
                return NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
            }
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionSearch, MovieSearch>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: MovieSearch) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                return nil
            }
            switch sectionIdentifier {
            case .foundMovies:
                return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: item)
            }
        }
    }
    
    private func setSearchViewController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search a movie here"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getMovies(movieName: String) {
        MovieNetworkManager.shared.searchMovies(query: movieName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(section: SectionSearch.foundMovies, movies: response.results)
            case .failure(let error):
                self.showAlertVC(title: "Did not find any results", message: error.rawValue, buttonTile: "OK")
            }
        }
    }
    
    private func updateUI(section: SectionSearch, movies: [MovieSearch]) {
        self.store.removeAll()
        self.store.append((section, movies))
        var snapshot = NSDiffableDataSourceSnapshot<SectionSearch, MovieSearch>()
        snapshot.appendSections([.foundMovies])
        snapshot.appendItems(movies, toSection: .foundMovies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
//    private func updateData(with store: [LayoutSectionMovieTuple]) {
//        var snapshot = NSDiffableDataSourceSnapshot<SectionSearch, MovieSearch>()
//        snapshot.appendSections([.foundMovies])
//        snapshot.appendItems(store[0].items, toSection: .foundMovies)
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = store[0].items[indexPath.row]
        let movieInfo = MovieInfoVC(id: movie.id)
        navigationController?.pushViewController(movieInfo, animated: true)
    }
}

extension MovieSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            self.store.removeAll()
            return
        }
        self.getMovies(movieName: filter)
    }
}

struct SearchViewControllersRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: MovieSearchViewController())
    }
}

struct SearchViewControllers_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SearchViewControllersRepresentable()
            .edgesIgnoringSafeArea(.vertical)
            .colorScheme(.dark)
    }
}

