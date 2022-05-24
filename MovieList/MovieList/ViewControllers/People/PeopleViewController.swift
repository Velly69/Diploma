//
//  PeopleViewController.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit
import SwiftUI

typealias LayoutActorsSectionItemsTuple = (title: String, layout: ActorsSectionLayout, items: [PopularActor])

class PeopleViewController: UIViewController {
    
    var backingStore: [LayoutActorsSectionItemsTuple] = []
    
    var dataSource: UICollectionViewDiffableDataSource<ActorsSectionLayout, PopularActor>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        configureHierarchy()
        setupCellAndSupplementaryRegistrations()
        configureDataSource()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    var avatarCellRegistration: UICollectionView.CellRegistration<AvatarCell, PopularActor>!
    var columnCellRegistration: UICollectionView.CellRegistration<ColumnCell, PopularActor>!
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
        columnCellRegistration = .init(cellNib: ColumnCell.nib, handler: { (cell, _, item) in
            cell.setup(item)
        })
        
        avatarCellRegistration = .init(cellNib: AvatarCell.nib, handler: { (cell, _, popularActor) in
            cell.setup(actor: popularActor)
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
            case .popularDirectors:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .estimated(1.0)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                section.supplementariesFollowContentInsets = false
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem(), self.supplemetarySeparatorFooterItem()]
                return section
            case .popularActorsCarousel:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let numberOfColumns = layoutEnvironment.traitCollection.horizontalSizeClass == .compact ? 3 : 6
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitem: item, count: numberOfColumns)
                group.interItemSpacing = .fixed(16)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
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
        dataSource = UICollectionViewDiffableDataSource<ActorsSectionLayout, PopularActor>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: PopularActor) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                return nil
            }
            switch sectionIdentifier {
            case .popularDirectors:
                return collectionView.dequeueConfiguredReusableCell(using: self.avatarCellRegistration, for: indexPath, item: item)
            case .popularActorsCarousel:
                return collectionView.dequeueConfiguredReusableCell(using: self.avatarCellRegistration, for: indexPath, item: item)
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
        MovieNetworkManager.shared.getPeople { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(title: "Famous Directors", section: ActorsSectionLayout.popularDirectors, actors: response.directors)
                self.updateUI(title: "Famous Actors", section: ActorsSectionLayout.popularActorsCarousel, actors: response.actors)
            case .failure(let error):
                self.showAlertVC(title: "Have some troubles", message: error.rawValue, buttonTile: "OK")
            }
        }
    }
    
    private func updateUI(title: String, section: ActorsSectionLayout, actors: [PopularActor]) {
        self.backingStore.append((title, section, actors))
        self.updateData(with: self.backingStore)
    }
    
    private func updateData(with backingstore: [LayoutActorsSectionItemsTuple]) {
        var snapshot = NSDiffableDataSourceSnapshot<ActorsSectionLayout, PopularActor>()
        backingStore.forEach { section in
            snapshot.appendSections([section.layout])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = backingStore[indexPath.section]
        let movie = section.items[indexPath.row]
        let movieInfo = MovieInfoVC(id: movie.id)
        navigationController?.pushViewController(movieInfo, animated: true)
    }
}

struct PeopleViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: PeopleViewController())
    }
}

struct PeopleViewController_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        PeopleViewControllerRepresentable()
            .edgesIgnoringSafeArea(.vertical)
    }
}
