//
//  MovieTabBarController.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

class MovieTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemRed
        UITabBar.appearance().barTintColor = .black
        self.viewControllers = [createMovieVC(), createPeopleVC(), createWatchLaterVC(), createSearchVC()]
    }
    
    private func createMovieVC() -> UINavigationController{
        let movieVC = MovieSectionViewController()
        movieVC.title = "Movies"
        movieVC.tabBarItem = UITabBarItem(title: "Movie List", image: UIImage(named: "icon-movie"), tag: 0)
        return UINavigationController(rootViewController: movieVC)
    }
    
    private func createPeopleVC() -> UINavigationController{
        let movieVC = PeopleViewController()
        movieVC.title = "People"
        movieVC.tabBarItem = UITabBarItem(title: "People", image: UIImage(named: "icon-hero"), tag: 1)
        return UINavigationController(rootViewController: movieVC)
    }

    private func createWatchLaterVC() -> UINavigationController{
        let watchLaterVC = WatchLaterVC()
        watchLaterVC.title = "Watch later"
        watchLaterVC.tabBarItem = UITabBarItem(title: "Watch Later", image: UIImage(named: "icon-popcorn"), tag: 2)
        return UINavigationController(rootViewController: watchLaterVC)
    }
    
    private func createSearchVC() -> UINavigationController{
        let watchLaterVC = MovieSearchViewController()
        watchLaterVC.title = "Search"
        watchLaterVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "icon-search"), tag: 3)
        return UINavigationController(rootViewController: watchLaterVC)
    }
}
