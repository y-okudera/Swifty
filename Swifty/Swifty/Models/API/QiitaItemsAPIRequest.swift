//
//  QiitaItemsAPIRequest.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

final class QiitaItemsAPIRequest: APIRequest {
    
    typealias Response = [QiitaItem]
    typealias ErrorResponse = QiitaItemsAPIErrorResponse
    let baseURL: URL = "https://qiita.com/api/v2".toURL()
    let path: String = "/items"
    var parameters: [String: Any] = [:]
    
    private let perPage = 50
    private var page: Int = 1 {
        didSet {
            self.parameters["page"] = "\(page)"
        }
    }
    var query: String {
        didSet {
            self.parameters["query"] = "\(query)"
            resetPage()
        }
    }
    
    init(query: String) {
        self.query = query
        createParameters()
    }
    
    private func createParameters() {
        self.parameters = [
            "page": "\(page)",
            "per_page": "\(perPage)",
            "query": query
        ]
    }
}

extension QiitaItemsAPIRequest {
    
    private func resetPage() {
        self.page = 1
    }
    
    func incrementPage() {
        self.page += 1
    }
    
    func decrementPage() {
        self.page -= 1
        if self.page <= 0 {
            self.page = 1
        }
    }
}

