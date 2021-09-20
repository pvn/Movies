//
//  TMDBMovieEndPoint.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

public enum TMDBMovieEndPoint {
    case nowPlaying(param: [String:Any])
    case reviews(movieId: String)
    case synopsys(movieId: String)
    case credits(movieId: String)
    case similar(movieId: String)
}

extension TMDBMovieEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .nowPlaying(param: _):
            return "now_playing"
        case .reviews(let movieId):
            return "\(movieId)/reviews"
        case .synopsys(let movieId):
            return "\(movieId)"
        case .credits(let movieId):
            return "\(movieId)/credits"
        case .similar(let movieId):
            return "\(movieId)/similar"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        let urlParams = ["api_key": "c7c86433e91bd846a70b75dd1487c39a", "language": "en-US", "page": 1, "Content-Type": "application/json"] as [String : Any]
        switch self {
        case .nowPlaying(param: _):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParams)
        case .reviews( _):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParams)
        case .synopsys( _):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParams)
        case .credits( _):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParams)
        case .similar( _):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParams)
        }
        
    }   

}
