//
//  EnvironmentConfiguration.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

public enum NetworkEnvironment {
    case none
    case production
}

class EnvironmentConfiguration {
    
    var environment: NetworkEnvironment = .none
    
    private var environmentBaseURL : String {
        switch environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .none: return "domain has not been set yet"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
}
