//
//  MovieListViewModel.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation
import UIKit

typealias PredicateResult<T> = (T) -> Bool

struct Predicate<Target> {
    var matches: (Target) -> Bool

    init(matcher: @escaping (Target) -> Bool) {
        matches = matcher
    }
}

class MovieItemView {
    var posterURL: URL?
    var movieTitle: String
    var movieReleaseDate: Date
    var posterImageData: Data?
    let movieId: String
    var image: UIImage!
    
    init(movie: Movie) {
        self.movieId = "\(movie.movieId)"
        self.movieTitle = movie.title
        self.movieReleaseDate = movie.releaseDate.toDate() ?? Date()
        self.posterURL = setURL(from: movie.posterPath)
        
    }
    
    func setURL(from imageEndPoint: String) -> URL {
        let imageURLPath = "https://image.tmdb.org/t/p/w200/\(imageEndPoint)"
        return URL(string: imageURLPath)!
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieId)
    }
    static func == (lhs: MovieItemView, rhs: MovieItemView) -> Bool {
        return lhs.movieId == rhs.movieId
    }
    
    func search(searchText: String) -> Bool {
        let words = self.movieTitle.words()
        let filtered = words.filter { $0.hasPrefix(searchText) }
        return (filtered.count != 0)
    }
}

class MovieListViewModel {
    
    var currentPage = 1
    var totalPages = 0
    var totalResults = 0
    var movies = [MovieItemView] ()
    var searchResults = [MovieItemView] ()
    
    init(nowPlaying: NowPlaying) {
        self.currentPage = nowPlaying.page
        self.totalPages = nowPlaying.totalPages
        self.totalResults = nowPlaying.totalResults
        
        for movie in nowPlaying.movies {
            let movieView = MovieItemView(movie: movie)
            movies.append(movieView)
        }
        
        
        movies = orderedMovies(list: movies)
        searchResults = movies
    }
}

extension MovieListViewModel {
    
    func search(searchText: String) -> [MovieItemView] {
        let results = self.items(matching: Predicate {
            !$0.movieTitle.contains(searchText)
        }, searchTest: searchText)
        print("Results \(results)")
        return results
    }
    
    func orderedMovies(list: [MovieItemView]) -> [MovieItemView] {
        return list.sorted(by: { $0.movieReleaseDate > $1.movieReleaseDate })
    }
    
    func items(matching predicate: Predicate<MovieItemView>, searchTest: String) -> [MovieItemView] {
        let andMatchPredicates: NSPredicate = NSPredicate(format: "SELF beginswith[c] %@", searchTest)
        let results = self.searchResults.filter { andMatchPredicates.evaluate(with: $0.movieTitle)}
        print("PKResults \(results)")
        return orderedMovies(list: results)
    }
}
