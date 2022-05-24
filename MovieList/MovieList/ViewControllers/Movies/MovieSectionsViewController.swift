//
//  MovieSectionsViewController.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit
import SwiftUI

typealias LayoutSectionItemsTuple = (title: String, layout: SectionLayout, items: [Movie])

class MovieSectionViewController: UIViewController {
    
    var backingStore: [LayoutSectionItemsTuple] = []
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayout, Movie>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movie Library"
        getMovies()
        configureHierarchy()
        setupCellAndSupplementaryRegistrations()
        configureDataSource()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    var bannerCellRegistration: UICollectionView.CellRegistration<BannerCell, Movie>!
    var headerRegistration: UICollectionView.SupplementaryRegistration<SectionHeaderTextReusableView>!
    var footerRegistration: UICollectionView.SupplementaryRegistration<SeparatorCollectionReusableView>!
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func setupCellAndSupplementaryRegistrations() {
        bannerCellRegistration = .init(cellNib: BannerCell.nib, handler: { (cell, _, item) in
            cell.setup(item)
        })
        
        headerRegistration = .init(supplementaryNib: SectionHeaderTextReusableView.nib, elementKind: UICollectionView.elementKindSectionHeader, handler: { (header, _, indexPath) in
            let title = self.backingStore[indexPath.section].title
            header.titleLabel.text = title
        })
        
        footerRegistration = .init(elementKind: UICollectionView.elementKindSectionFooter, handler: { (_, _, _) in })
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sectionIdentifier {
            case .topRatedBannerCarousel, .popularBannerCarousel, .nowPlayingBannerCarousel:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75), heightDimension: .estimated(1.0)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 15
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                section.supplementariesFollowContentInsets = false
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem(), self.supplemetarySeparatorFooterItem()]
                return section
            }
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func supplemetarySeparatorFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayout, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Movie) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                return nil
            }
            switch sectionIdentifier {
            case .nowPlayingBannerCarousel, .popularBannerCarousel, .topRatedBannerCarousel:
                return collectionView.dequeueConfiguredReusableCell(using: self.bannerCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: self.footerRegistration, for: indexPath)
            }
        }
    }
    
    private func getMovies() {
        MovieNetworkManager.shared.getMovies(from: .topRated) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(title: "Top-20", section: SectionLayout.topRatedBannerCarousel, movies: response.results)
            case .failure(let error):
                self.showAlertVC(title: "Have some troubles", message: error.rawValue, buttonTile: "OK")
            }
        }
        
        MovieNetworkManager.shared.getMovies(from: .upcoming) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(title: "Soon in the cinema", section: SectionLayout.nowPlayingBannerCarousel, movies: response.results)
            case .failure(let error):
                self.showAlertVC(title: "Have some troubles", message: error.rawValue, buttonTile: "OK")
            }
        }
        
        MovieNetworkManager.shared.getMovies(from: .popular) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(title: "Popular now", section: SectionLayout.popularBannerCarousel, movies: response.results)
            case .failure(let error):
                self.showAlertVC(title: "Have some troubles", message: error.rawValue, buttonTile: "OK")
            }
        }
        
    }
    
    private func updateUI(title: String, section: SectionLayout, movies: [Movie]) {
        self.backingStore.append((title, section, movies))
        self.updateData(with: self.backingStore)
    }
    
    private func updateData(with backingstore: [LayoutSectionItemsTuple]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayout, Movie>()
        backingStore.forEach { section in
            snapshot.appendSections([section.layout])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MovieSectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = backingStore[indexPath.section]
        let movie = section.items[indexPath.row]
        let movieInfo = MovieInfoVC(id: movie.id)
        navigationController?.pushViewController(movieInfo, animated: true)
    }
}

struct ViewControllersRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: MovieSectionViewController())
    }
}

struct ViewControllers_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ViewControllersRepresentable()
            .edgesIgnoringSafeArea(.vertical)
    }
}
