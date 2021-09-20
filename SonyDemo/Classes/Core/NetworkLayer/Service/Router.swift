//
//  NetworkService.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 18/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ error: String?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        if (isConnectedToNetwork()) {
            let session = URLSession.shared
            do {
                let request = try self.buildRequest(from: route)
                NetworkLogger.log(request: request)
                task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if self.isAuthenticated(data: data) {
                        
                        if let response = response as? HTTPURLResponse {
                            let result = ResponseStatusHandler.handleNetworkResponse(response)
                            switch result {
                            case .success:
                                guard let responseData = data else {
                                    completion(nil, ResponseStatus.noData.rawValue)
                                    return
                                }
                                do {
                                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                                    print(jsonData)
                                    completion(responseData, nil)
                                }catch {
                                    print(error)
                                    completion(nil, ResponseStatus.noData.rawValue)
                                }
                            case .failure(let error):
                                print(error)
                                completion(nil, error)
                            }
                        }
                    }
                })
            }catch {
                completion(nil, ResponseStatus.failed.rawValue)
            }
            self.task?.resume()
        }
        else {
            completion(nil, ResponseStatus.failed.rawValue)
        }
    }
    
    
    func isAuthenticated(data: Data?) -> Bool {
       return true
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        let config = EnvironmentConfiguration()
        config.environment = route.environment
        var request = URLRequest(url: config.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)

            case .requestJson(let bodyParameters, let additionalHeaders):
                guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters!, options: []) else {
                    return request
                }
                request.httpBody = httpBody
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                break
                //
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func prettyPrint(with responseData: Data) -> NSString {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! [String: Any]
            let data = try! JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            return jsonString!
        } catch let myJSONError {
            print(myJSONError)
            return "Could not convert to json"
        }
        
    }
    
    func isConnectedToNetwork() -> Bool {
        let reachablity = NetworkReachabilityManager()
        return reachablity!.isReachable
    }
}

