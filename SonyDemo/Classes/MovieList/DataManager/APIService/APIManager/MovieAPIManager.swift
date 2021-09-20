//
//  MovieListAPIManager.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

typealias MovieListAPICompletion = (_ json: Data?, _ error: String?) -> ()

class MovieAPIManager: NSObject {
    
    //MARK: list of movies
    func nowPlaying(completion: @escaping MovieListAPICompletion) {
        let router = Router<TMDBMovieEndPoint>()
        
        router.request(.nowPlaying(param: [:])) { (data, error) in
            completion(data, error)
        }
    }
    
    //MARK: Review of particular movie
    func reviews(movieId:String, completion: @escaping MovieListAPICompletion) {
        let router = Router<TMDBMovieEndPoint>()
        
        router.request(.reviews(movieId: movieId)) { (data, error) in
            completion(data, error)
        }
    }
    
    //MARK: Synopsys of particular movie
    func synopsys(movieId:String, completion: @escaping MovieListAPICompletion) {
        let router = Router<TMDBMovieEndPoint>()
        
        router.request(.synopsys(movieId: movieId)) { (data, error) in
            completion(data, error)
        }
    }
    
    //MARK: Credits of particular movie
    func credits(movieId:String, completion: @escaping MovieListAPICompletion) {
        let router = Router<TMDBMovieEndPoint>()
        
        router.request(.credits(movieId: movieId)) { (data, error) in
            completion(data, error)
        }
    }
    
    //MARK: Similar of particular movie
    func similar(movieId:String, completion: @escaping MovieListAPICompletion) {
        let router = Router<TMDBMovieEndPoint>()
        
        router.request(.similar(movieId: movieId)) { (data, error) in
            completion(data, error)
        }
    }
}
