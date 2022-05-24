//
//  WatchLaterVC.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

class WatchLaterVC: MovieLoadingDataVC {
    private let tableView = UITableView()
    private var watchLater: [Movie] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMoviesToWatch()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.register(WatchLaterCell.self, forCellReuseIdentifier: WatchLaterCell.reuseID)
    }
    
    private func getMoviesToWatch() {
        UserDefaultsManager.getMoviesToWatch { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.updateUI(with: movies)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func updateUI(with movies: [Movie]) {
        if movies.isEmpty {
            print("No movies to watch :c")
        } else {
            self.watchLater = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension WatchLaterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchLater.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchLaterCell.reuseID) as! WatchLaterCell
        let movieWL = watchLater[indexPath.row]
        cell.set(movieWL: movieWL)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieWL = watchLater[indexPath.row]
        let destinationvVC = MovieInfoVC(id: movieWL.id)
        navigationController?.pushViewController(destinationvVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        UserDefaultsManager.update(with: watchLater[indexPath.row], actionType: .remove) { [weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.watchLater.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
                return
            }
            print(error.rawValue)
        }
    }
    
}
