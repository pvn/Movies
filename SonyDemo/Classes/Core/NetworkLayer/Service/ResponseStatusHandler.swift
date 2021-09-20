//
//  NetworkError.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

enum Result<String>{
    case success
    case failure(String)
}

public enum ResponseStatus:String {
    case success
    case authenticationError = "You are not authorized to view this content!"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case failed = "You're not connected to the internet. Check your Internet Connection and try again"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
    case internalServerError = "Something went wrong, Please try again later"
    case sessionExpire = "Your session expired due to inactivity"
    case timeout = "Please respond within '2' minutes to continue."
    case generic = "We have encountered an error"
    case permission = "Object view permission not allowed"
}

class ResponseStatusHandler: NSObject {
    
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401: return .failure(ResponseStatus.authenticationError.rawValue)
        case 402...500: return .failure(ResponseStatus.internalServerError.rawValue)
        case 501...599: return .failure(ResponseStatus.badRequest.rawValue)
        case 600: return .failure(ResponseStatus.outdated.rawValue)
        default: return .failure(ResponseStatus.failed.rawValue)
        }
    }
}

public enum ErrorTitle:String {
    case networkError = "Connection Error"
    case sessionTimeout = "Timed Out"
    case internalServerError = "Error"
    case timeout = "Response Timeout"
    case generic = "Error occurred"
    case permission = "Permission Error"
}

class RequestErrorHandler: NSObject {
    
    static func mapErrorDescription(_ errorTitle: String) -> String {
        switch errorTitle {
        case ErrorTitle.networkError.rawValue:
            return ResponseStatus.failed.rawValue
        case ErrorTitle.sessionTimeout.rawValue:
            return ResponseStatus.sessionExpire.rawValue
        case ErrorTitle.internalServerError.rawValue:
            return ResponseStatus.internalServerError.rawValue
        case ErrorTitle.timeout.rawValue:
            return ResponseStatus.timeout.rawValue
        case ErrorTitle.generic.rawValue:
            return ResponseStatus.generic.rawValue
        case ErrorTitle.permission.rawValue:
            return ResponseStatus.permission.rawValue
        default:
            return ResponseStatus.internalServerError.rawValue
        }
    }
}


