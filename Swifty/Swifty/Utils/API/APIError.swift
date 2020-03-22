//
//  APIError.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

enum APIError: Error {
    /// 認証に失敗した場合、または未認証(HTTP status code 401)
    case unauthorized
    /// リソースにアクセスすることを拒否された(HTTP status code 403)
    case forbidden
    /// 接続エラー(オフライン)
    case connectionError
    /// タイムアウト
    case timedOut
    /// レスポンスのデコード失敗
    case decodeError
    /// エラーレスポンス
    case errorResponse(errObject: Decodable)
    /// 無効なリクエスト
    case invalidRequest
    /// 無効なレスポンス
    case invalidResponse
    /// その他
    case others(error: Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .unauthorized:
                return "Unauthorized".localized()
            case .forbidden:
                return "Forbidden".localized()
            case .connectionError:
                return "ConnectionError".localized()
            case .timedOut:
                return "TimedOut".localized()
            case .decodeError:
                return "DecodeError".localized()
            case .errorResponse(errObject: let errObject):
                return apiErrorMessage(errObject: errObject)
            case .invalidRequest:
                return "InvalidRequest".localized()
            case .invalidResponse:
                return "InvalidResponse".localized()
            case .others:
                return "DefaultErrorMessage".localized()
        }
    }
    
    private func apiErrorMessage(errObject: Decodable) -> String {
        var errorMessage = "DefaultErrorResponse".localized()
        
        // QiitaItemsAPIRequestの場合
        if let message = (errObject as? QiitaItemsAPIErrorResponse)?.message {
            errorMessage = message
        }
        return errorMessage
    }
}

