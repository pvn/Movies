//
//  ResponseDataHandler.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

public typealias APIResponseCompletion = (_ jsonData: Any?, _ error: String?)->()

protocol URLResponseDataHandler {
//    func handleResponseData(_ data: Data?,_ response: URLResponse?,_ error: Error?, completion: @escaping APIResponseCompletion)
}

class ResponseDataHandler: URLResponseDataHandler {
    func handleResponseData(_ data: Data?,_ response: URLResponse?,_ error: Error?, completion: @escaping APIResponseCompletion) {

        if error != nil {
            completion(nil, ErrorTitle.networkError.rawValue)
        }
        else {
            
            if let response = response as? HTTPURLResponse {
                let result = ResponseStatusHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    //responseData received from response
                    guard let responseData = data else {
                        completion(nil, ResponseStatus.noData.rawValue)
                        return
                    }
                    do {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print("JSON VALUE \(jsonData)")
                        completion(jsonData,nil)
                    }catch {
                        print(error)
                        completion(nil, ResponseStatus.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        
    }
}
