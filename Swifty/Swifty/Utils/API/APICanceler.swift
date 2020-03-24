//
//  APICanceler.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/25.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation

final class APICanceler {
    
    static let shared = APICanceler()
    private init() {}
    
    private var dataRequestArray = [Alamofire.DataRequest]()
    
    func append(dataRequest: Alamofire.DataRequest) {
        removeFinishedAndCancelledDataRequest()
        dataRequestArray.append(dataRequest)
    }
    
    func allCancel() {
        removeFinishedAndCancelledDataRequest()
        cancelAndRemove(targetArray: self.dataRequestArray)
    }
    
    func cancel(urlRequest: URLRequest) {
        removeFinishedAndCancelledDataRequest()
        let target = self.dataRequestArray.filter { $0.request == urlRequest }
        cancelAndRemove(targetArray: target)
    }
    
    func cancel(url: URL) {
        removeFinishedAndCancelledDataRequest()
        let target = self.dataRequestArray.filter { dataRequest -> Bool in
            guard let requestUrl = dataRequest.request?.url else {
                return false
            }
            if requestUrl == url {
                return true
            }
            return false
        }
        cancelAndRemove(targetArray: target)
    }
}

extension APICanceler {
    
    private func remove(dataRequest: Alamofire.DataRequest) {
        if let index = dataRequestArray.firstIndex(of: dataRequest) {
            dataRequestArray.remove(at: index)
        }
    }
    
    private func removeFinishedAndCancelledDataRequest() {
        let target = self.dataRequestArray.filter { $0.isFinished || $0.isCancelled }
        target.forEach { self.remove(dataRequest: $0) }
    }
    
    private func cancelAndRemove(targetArray: [Alamofire.DataRequest]) {
        targetArray.forEach { dataRequest in
            dataRequest.cancel()
            self.remove(dataRequest: dataRequest)
        }
    }
}

