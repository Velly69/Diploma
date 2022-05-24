//
//  MovieInfoVC.swift
//  MovieList
//
//  Created by Alexander Totsky on 04.05.2022.
//

import UIKit

class MovieInfoVC: MovieLoadingDataVC {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    //private let creditsView = UIView()
    
    private var itemViews: [UIView] = []
    
    private var id: Int!
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    override func viewDidLoad() {
        configureViewController()
        configureScrollView()
        layoutUI()
        getMovieInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        showLoadingView()
        
        MovieNetworkManager.shared.getMovie(id: id) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let movie):
                self.addMovieToWatchLater(movie: movie)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addMovieToWatchLater(movie: MovieInfo) {
        let movie = Movie(title: movie.title, posterPath: movie.posterPath, voteAverage: movie.voteAverage ?? 1.0, id: movie.id, genres: movie.genres)
        
        UserDefaultsManager.update(with: movie, actionType: .add) { [weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.showAlertVC(title: "Great!", message: "You have added a movie to your watch list!", buttonTile: "Wow!")
                return
            }
            self.showAlertVC(title: "Something wrong...", message: error.rawValue, buttonTile: "OK")
        }
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        itemViews = [headerView]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 500),
        ])
    }
    
    private func getMovieInfo() {
        MovieNetworkManager.shared.getMovie(id: id) { (result) in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self.configureUIElements(with: movie)
                }
                
            case .failure(let error):
                self.showAlertVC(title: "Something wrong...", message: error.rawValue, buttonTile: "OK")
            }
        }
    }
    
    private func configureUIElements(with movie: MovieInfo) {
        self.add(childVC: MovieInfoMainVC(movieInfo: movie), to: self.headerView)
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
