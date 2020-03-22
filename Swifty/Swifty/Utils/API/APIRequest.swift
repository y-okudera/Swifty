//
//  APIRequest.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - Protocol
protocol APIRequest {
    
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var encodingType: EncodingType { get }
    var httpHeaderFields: [String: String] { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var allowsCellularAccess: Bool { get }
    
    func decode(errorResponseData: Data) -> ErrorResponse?
    func makeURLRequest() -> URLRequest?
}

// MARK: - Default implementation
extension APIRequest {
    
    var baseURL: URL {
        let url = "https://dummy.restapiexample.com/api/v1".toURL()
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/employees"
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var encodingType: EncodingType {
        return .urlEncoding
    }
    
    var httpHeaderFields: [String: String] {
        return [:]
    }
    
    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var allowsCellularAccess: Bool {
        return true
    }
    
    func decode(errorResponseData: Data) -> ErrorResponse? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(ErrorResponse.self, from: errorResponseData)
        } catch {
            print(debug: "ErrorResponse decode error:\(error)")
            return nil
        }
    }
    
    func makeURLRequest() -> URLRequest? {
        
        let endPoint = baseURL.absoluteString + path
        
        // String to URL
        let url = endPoint.toURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        urlRequest.allowsCellularAccess = allowsCellularAccess
        
        // Encoding request parameters
        switch encodingType {
            case .jsonEncoding:
                return urlRequest.jsonEncoding(parameters: parameters)
            case .urlEncoding:
                return urlRequest.urlEncoding(parameters: parameters)
        }
    }
}

// MARK: - Private func
private extension URLRequest {
    
    /// URLEncoding
    ///
    /// - Parameter parameters: Dictionary of request parameters
    /// - Returns: URLRequest
    mutating func urlEncoding(parameters: [String: Any]) -> URLRequest? {
        do {
            self = try Alamofire.URLEncoding.default.encode(self, with: parameters)
            return self
        } catch {
            assertionFailure("URLEncoding error occurred\nURLRequest:\(self)")
            return nil
        }
    }
    
    /// JSONEncoding
    ///
    /// - Parameter parameters: Dictionary of request parameters
    /// - Returns: URLRequest
    mutating func jsonEncoding(parameters: [String: Any]) -> URLRequest? {
        do {
            self = try Alamofire.JSONEncoding.default.encode(self, with: parameters)
            return self
        } catch {
            assertionFailure("JSONEncoding error occurred\nURLRequest:\(self)")
            return nil
        }
    }
}

