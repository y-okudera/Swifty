//
//  NetworkReachabilityError.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

enum NetworkReachabilityError: Error {
    case notReachable
    case onlyViaWiFi
}

extension NetworkReachabilityError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .notReachable:
                return "NotReachable".localized()
            case .onlyViaWiFi:
                return "OnlyViaWiFi".localized()
        }
    }
}

