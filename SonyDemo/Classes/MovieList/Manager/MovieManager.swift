//
//  MovieListManager.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//

import UIKit

protocol MovieListUIUseCase {
    func displayMovies(movieListVM: MovieListViewModel)
    func updateUIOnFailure(error: String)
}

class MovieManager: NSObject {
    
    private var movieListViewModel: MovieListViewModel?
    let nowPlayingAPIManager = MovieAPIManager()
    private var nowPlayingVC: MovieListUIUseCase
    
    init(delegate: MovieListUIUseCase) {
        self.nowPlayingVC = delegate
    }
    
    func movies() {
        nowPlayingAPIManager.nowPlaying { data, error in
            
            guard let data = data, error == nil else {
                self.nowPlayingVC.updateUIOnFailure(error: error!)
                return
            }
            do {
                let nowPlaying = try JSONDecoder().decode(NowPlaying.self, from: data as Any as! Data)
                self.movieListViewModel = MovieListViewModel(nowPlaying: nowPlaying)
                self.nowPlayingVC.displayMovies(movieListVM: self.movieListViewModel!)
            }
            catch let error {
                print("JSON Error \(error)")
            }
        }
    }
    
    func reviews(movieId: String) {
        
        nowPlayingAPIManager.reviews(movieId: movieId) { data, error in
            guard let data = data, error == nil else {
                self.nowPlayingVC.updateUIOnFailure(error: error!)
                return
            }
            do {
                let nowPlaying = try JSONDecoder().decode(NowPlaying.self, from: data as Any as! Data)
                self.movieListViewModel = MovieListViewModel(nowPlaying: nowPlaying)
                self.nowPlayingVC.displayMovies(movieListVM: self.movieListViewModel!)
            }
            catch let error {
                print("JSON Error \(error)")
            }
        }
    }
    
    func synopsys(movieId: String) {
        
        nowPlayingAPIManager.synopsys(movieId: movieId) { data, error in
            guard let data = data, error == nil else {
                self.nowPlayingVC.updateUIOnFailure(error: error!)
                return
            }
            do {
                //TODO: Need to use JSONDecoder to create a Synopsys model
                let synopsys = try JSONDecoder().decode(NowPlaying.self, from: data as Any as! Data)
                print(synopsys)
            }
            catch let error {
                print("JSON Error \(error)")
            }
        }
    }
    
    func credits(movieId: String) {
        
        nowPlayingAPIManager.credits(movieId: movieId) { data, error in
            guard let data = data, error == nil else {
                self.nowPlayingVC.updateUIOnFailure(error: error!)
                return
            }
            do {
                //TODO: Need to use JSONDecoder to create a Credit model
                let credits = try JSONDecoder().decode(NowPlaying.self, from: data as Any as! Data)
                print(credits)
            }
            catch let error {
                print("JSON Error \(error)")
            }
        }
    }
    
    func similarMovies(movieId: String) {
        
        nowPlayingAPIManager.similar(movieId: movieId) { data, error in
            guard let data = data, error == nil else {
                self.nowPlayingVC.updateUIOnFailure(error: error!)
                return
            }
            do {
                //TODO: Need to use JSONDecoder to create a Similar movie model
                let similarMovies = try JSONDecoder().decode(NowPlaying.self, from: data as Any as! Data)
                print(similarMovies)
            }
            catch let error {
                print("JSON Error \(error)")
            }
        }
    }
}

