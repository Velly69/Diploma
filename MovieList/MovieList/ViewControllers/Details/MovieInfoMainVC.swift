//
//  MovieInfoHeaderVC.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

typealias LayoutCastSectionItemsTuple = (title: String, layout: CastSectionLayout, items: [MovieCast])

final class MovieInfoMainVC: UIViewController {
    private let movieImageView = MovieImageView(frame: .zero)
    private let nameLabel = MovieTitleLabel(fontSize: 24, textColor: .black, weight: .bold, alignment: .center)
    private let releaseYearLabel = MovieTitleLabel(fontSize: 14, textColor: .black, weight: .regular, alignment: .center)
    private let genreLabel = MovieTitleLabel(fontSize: 14, textColor: .black, weight: .regular, alignment: .center)
    private let timeLabel = MovieTitleLabel(fontSize: 14, textColor: .black, weight: .regular, alignment: .center)
    private let descriptionTitleLabel = MovieTitleLabel(fontSize: 20, textColor: .black, weight: .bold, alignment: .left)
    private let descriptionLabel = MovieTitleLabel(fontSize: 18, textColor: .black, weight: .regular, alignment: .left)
    
    var backingStore: [LayoutCastSectionItemsTuple] = []
    var dataSource: UICollectionViewDiffableDataSource<CastSectionLayout, MovieCast>! = nil
    var collectionView: UICollectionView! = nil
    var avatarCellRegistration: UICollectionView.CellRegistration<AvatarCell, MovieCast>!
    var headerRegistration: UICollectionView.SupplementaryRegistration<SectionHeaderTextReusableView>!
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var movieInfo: MovieInfo!
    
    init(movieInfo: MovieInfo) {
        super.init(nibName: nil, bundle: nil)
        self.movieInfo = movieInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNameLabelAndMovieImageView()
        setupStackView()
        setupVerticalStackView()
        setupCollectionView()
        setupCellAndSupplementaryRegistrations()
        setupDataSource()
        getActors()
        configureUI()
    }
    
    // MARK: - UI
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        verticalStackView.addArrangedSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupCellAndSupplementaryRegistrations() {
        avatarCellRegistration = .init(cellNib: AvatarCell.nib, handler: { (cell, _, cast) in
            cell.setup(cast: cast)
        })
        
        headerRegistration = .init(supplementaryNib: SectionHeaderTextReusableView.nib, elementKind: UICollectionView.elementKindSectionHeader, handler: { (header, _, indexPath) in
            let title = self.backingStore[indexPath.section].title
            header.titleLabel.text = title
        })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sectionIdentifier {
            case .actorsCarousel:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .estimated(1.0)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                section.supplementariesFollowContentInsets = false
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            }
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CastSectionLayout, MovieCast>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: MovieCast) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                return nil
            }
            switch sectionIdentifier {
            case .actorsCarousel:
                return collectionView.dequeueConfiguredReusableCell(using: self.avatarCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
                return collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func setupNameLabelAndMovieImageView() {
        view.addSubviews(nameLabel, movieImageView)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            movieImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func setupStackView() {
        view.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        infoStackView.addArrangedSubview(releaseYearLabel)
        infoStackView.addArrangedSubview(genreLabel)
        infoStackView.addArrangedSubview(timeLabel)
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(descriptionTitleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            verticalStackView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func configureUI() {
        movieImageView.downloadPosterImage(fromURL: movieInfo.backdropStringURL)
        nameLabel.text = movieInfo.title
        descriptionLabel.text = movieInfo.overview
        descriptionTitleLabel.text = "Description"
        releaseYearLabel.text = "😎Year: \(movieInfo.yearText) "
        genreLabel.text = "🎬Genre: \(movieInfo.genreText)"
        timeLabel.text = "⏳Time: \(movieInfo.time)"
    }
    
    // MARK: - Business Logic
    
    private func getActors() {
        self.updateUI(title: "Actors", section: CastSectionLayout.actorsCarousel, actors: Array(movieInfo.cast?.prefix(15) ?? []))
    }
    
    private func updateUI(title: String, section: CastSectionLayout, actors: [MovieCast]) {
        self.backingStore.append((title, section, actors))
        self.updateData(with: self.backingStore)
    }
    
    private func updateData(with backingstore: [LayoutCastSectionItemsTuple]) {
        var snapshot = NSDiffableDataSourceSnapshot<CastSectionLayout, MovieCast>()
        backingStore.forEach { section in
            snapshot.appendSections([section.layout])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - CollectionViewDelegate Methods
extension MovieInfoMainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = backingStore[indexPath.section]
        let actor = section.items[indexPath.row]
        let movieInfo = PersonInfoDetailViewController(personID: actor.id)
        navigationController?.pushViewController(movieInfo, animated: true)
    }
}
