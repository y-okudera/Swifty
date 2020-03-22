//
//  APIClient.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

struct APIClient {
    
    /// ネットワーク状態をチェックする
    ///
    /// - Parameters:
    ///   - onlyViaWiFi: Wi-Fiのみ許容するかどうか
    ///   true: Wi-Fiのみ許容, false: Wi-FiもCellularも許容
    ///
    /// - Returns: true: 接続成功, false: 接続失敗
    static func isReachable(onlyViaWiFi: Bool = false) -> Promise<Void> {
        
        return Promise<Void> { resolver in
            guard let reachabilityManager = NetworkReachabilityManager() else {
                resolver.reject(NetworkReachabilityError.notReachable)
                return
            }
            
            reachabilityManager.startListening { networkReachabilityStatus in
                switch networkReachabilityStatus {
                    case .notReachable:
                        print(debug: "The network is not reachable.")
                        resolver.reject(NetworkReachabilityError.notReachable)
                    
                    case .reachable(.ethernetOrWiFi):
                        print(debug: "The network is reachable over the WiFi connection")
                        resolver.fulfill(())
                    
                    case .reachable(.cellular):
                        print(debug: "The network is reachable over the WWAN connection")
                        onlyViaWiFi
                            ? resolver.reject(NetworkReachabilityError.onlyViaWiFi)
                            : resolver.fulfill(())
                    
                    case .unknown:
                        print(debug: "It is unknown whether the network is reachable.")
                        resolver.reject(NetworkReachabilityError.notReachable)
                }
            }
        }
    }
    
    /// API Request
    static func request<T: APIRequest>(request: T) -> Promise<Decodable> {
        
        return Promise<Decodable> { resolver in
            
            guard let urlRequest = request.makeURLRequest() else {
                resolver.reject(APIError.invalidRequest)
                return
            }
            print(debug: "urlRequest")
            dump(debug: urlRequest)
            
            let queue: DispatchQueue = .main
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoder: DataDecoder = jsonDecoder
            
            AF.request(urlRequest)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: T.Response.self, queue: queue, decoder: decoder) { afDataResponse in
                    
                    // check http status code
                    if let statusCodeError = verifyResponseStatusCode(response: afDataResponse.response) {
                        resolver.reject(statusCodeError)
                        return
                    }
                    
                    // check response data is not nil.
                    guard let data = afDataResponse.data else {
                        let apiError = afErrorToAPIError(afError: afDataResponse.error)
                        resolver.reject(apiError)
                        return
                    }
                    
                    switch afDataResponse.result {
                        case .success(let response):
                            print(debug: "API Response")
                            dump(debug: response)
                            resolver.fulfill(response)
                        
                        case .failure(let afError):
                            
                            // Whether the instance is `.responseSerializationFailed`.
                            if afError.isResponseSerializationError {
                                let apiError = decodeErrorResponse(errorResponseData: data, request: request)
                                resolver.reject(apiError)
                                return
                            }
                            
                            let apiError = afErrorToAPIError(afError: afError)
                            resolver.reject(apiError)
                    }
            }
        }
    }
}

extension APIClient {
    
    /// Verify http status code.
    private static func verifyResponseStatusCode(response: HTTPURLResponse?) -> APIError? {
        guard let status = response?.status else {
            print(debug: "Invalid http status code.")
            return .invalidResponse
        }
        print(debug: "HTTP status", status)
        
        switch status {
            case .unauthorized:
                return .unauthorized
            case .forbidden:
                return .forbidden
            default:
                break
        }
        return nil
    }
    
    /// Convert error type from AFError to APIError.
    private static func afErrorToAPIError(afError: AFError?) -> APIError {
        
        guard let afError = afError else {
            print(debug: "data and error are nil.")
            return .invalidResponse
        }
        print(debug: "AFError:\(afError)")
        
        if case .sessionTaskFailed(error: let error) = afError {
            if let urlError = error as? URLError {
                switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        return .connectionError
                    case .timedOut:
                        return .timedOut
                    default:
                        break
                }
            }
        }
        return .others(error: afError)
    }
    
    /// Decode the error response data.
    ///
    /// - Parameters:
    ///   - errorResponseData: API error data
    ///   - request: APIRequest
    /// - Returns: APIError
    private static func decodeErrorResponse<T: APIRequest>(errorResponseData: Data, request: T) -> APIError {
        if let apiErrorObject = request.decode(errorResponseData: errorResponseData) {
            print(debug: "apiErrorObject:\(apiErrorObject)")
            return .errorResponse(errObject: apiErrorObject)
        }
        
        print(debug: "Decoding failure.")
        return .decodeError
    }
}

