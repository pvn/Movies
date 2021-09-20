//
//  EndPoint.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

protocol EndPointType {
    //var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders { get }
    var environment: NetworkEnvironment { get }
}

extension EndPointType {
    
    var environment: NetworkEnvironment {
        return NetworkEnvironment.production
    }
    
    var headers : HTTPHeaders {
        return["TenantId":""]
    }
}

