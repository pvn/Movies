//
//  HTTPTask.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    
    case requestJson(bodyParameters: Any?, additionHeaders: HTTPHeaders?)
    
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
