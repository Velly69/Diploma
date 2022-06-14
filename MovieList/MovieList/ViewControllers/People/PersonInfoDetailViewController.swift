//
//  PersonInfoDetailViewController.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 10.06.2022.
//

import Foundation
import UIKit

typealias LayoutPersonMoviesSectionItemsTuple = (title: String, layout: PersonMovieSectionLayout, items: [PersonMovie])

final class PersonInfoDetailViewController: MovieLoadingDataVC {
    private var personID: Int!
    private var personInfo: PersonInfo!
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var infoAndShowsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var backingStore: [LayoutPersonMoviesSectionItemsTuple] = []
    var dataSource: UICollectionViewDiffableDataSource<PersonMovieSectionLayout, PersonMovie>! = nil
    var collectionView: UICollectionView! = nil
    var bannerCellRegistration: UICollectionView.CellRegistration<BannerCell, PersonMovie>!
    var headerRegistration: UICollectionView.SupplementaryRegistration<SectionHeaderTextReusableView>!
    
    private let photoImageView = MovieImageView(frame: .zero)
    private let nameLabel = MovieTitleLabel(fontSize: 24, textColor: .black, weight: .bold, alignment: .center)
    private let countryLabel = MovieTitleLabel(fontSize: 16, textColor: .black, weight: .semibold, alignment: .left)
    private let birthdayLabel = MovieTitleLabel(fontSize: 16, textColor: .black, weight: .semibold, alignment: .left)
    private let genderLabel = MovieTitleLabel(fontSize: 16, textColor: .black, weight: .semibold, alignment: .left)
    
    init(personID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.personID = personID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        getPersonInfo()
        setupNameLabel()
        setupPhotoImageView()
        setupVerticalStackView()
        setupInfoAndShowsStackView()
        setupCollectionView()
        setupCellAndSupplementaryRegistrations()
        setupDataSource()
        getPersonMovies()
    }
    
    // MARK: - UI
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupPhotoImageView() {
        view.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoImageView.heightAnchor.constraint(equalToConstant: 250),
            photoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            verticalStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            verticalStackView.heightAnchor.constraint(equalToConstant: 120),
            verticalStackView.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        verticalStackView.addArrangedSubview(countryLabel)
        verticalStackView.addArrangedSubview(birthdayLabel)
        verticalStackView.addArrangedSubview(genderLabel)
    }
    
    private func setupInfoAndShowsStackView() {
        view.addSubview(infoAndShowsStackView)
        infoAndShowsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoAndShowsStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15),
            infoAndShowsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoAndShowsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoAndShowsStackView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        infoAndShowsStackView.addArrangedSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: infoAndShowsStackView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: infoAndShowsStackView.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupCellAndSupplementaryRegistrations() {
        bannerCellRegistration = .init(cellNib: BannerCell.nib, handler: { (cell, _, cast) in
            cell.setup(personMovie: cast)
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
            case .moviesCarousel:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75), heightDimension: .estimated(1.0)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 15
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                section.supplementariesFollowContentInsets = false
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            }
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PersonMovieSectionLayout, PersonMovie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: PersonMovie) -> UICollectionViewCell? in
            guard let sectionIdentifier = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else {
                return nil
            }
            switch sectionIdentifier {
            case .moviesCarousel:
                return collectionView.dequeueConfiguredReusableCell(using: self.bannerCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
                return collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }

    // MARK: - Business Logic
    private func getPersonInfo() {
        MovieNetworkManager.shared.getPersonInfo(id: personID) { result in
            switch result {
            case .success(let person):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.personInfo = person
                    self.updateUI()
                }
            case .failure(let error):
                self.showAlertVC(title: "Something wrong...", message: error.rawValue, buttonTile: "OK")
                return
            }
        }
    }
    
    private func updateUI() {
        photoImageView.downloadPosterImage(fromURL: personInfo.profilePictureStringURL)
        nameLabel.text = personInfo.name
        countryLabel.text = "Place of birth: \(personInfo.placeOfBirth)"
        birthdayLabel.text = "Birthday: \(personInfo.birthday)"
        genderLabel.text = "Gender: \(personInfo.gender == 1 ? "Female" : "Male")"
    }
    
    private func getPersonMovies() {
        MovieNetworkManager.shared.getPersonShows(id: personID) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.updateUI(title: "Shows", section: PersonMovieSectionLayout.moviesCarousel, actors: response.cast)
            case .failure(let error):
                self.showAlertVC(title: "Have some troubles", message: error.rawValue, buttonTile: "OK")
            }
        }
    }
    
    private func updateUI(title: String, section: PersonMovieSectionLayout, actors: [PersonMovie]) {
        self.backingStore.append((title, section, actors))
        self.updateData(with: self.backingStore)
    }
    
    private func updateData(with backingstore: [LayoutPersonMoviesSectionItemsTuple]) {
        var snapshot = NSDiffableDataSourceSnapshot<PersonMovieSectionLayout, PersonMovie>()
        backingStore.forEach { section in
            snapshot.appendSections([section.layout])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PersonInfoDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = backingStore[indexPath.section]
        let movie = section.items[indexPath.row]
        let movieInfo = MovieInfoViewController(id: movie.id)
        navigationController?.pushViewController(movieInfo, animated: true)
    }
}
