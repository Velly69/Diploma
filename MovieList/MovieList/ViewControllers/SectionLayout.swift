//
//  SectionLayout.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

enum SectionLayout: Hashable {
    case topRatedBannerCarousel
    case nowPlayingBannerCarousel
    case popularBannerCarousel
}

enum ActorsSectionLayout: Hashable {
    case popularActorsCarousel
    case popularDirectors
}

enum CastSectionLayout: Hashable {
    case actorsCarousel
}

enum PersonMovieSectionLayout: Hashable {
    case moviesCarousel
}

enum SectionSearch {
    case foundMovies
}
