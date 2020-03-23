//
//  QiitaSearchModel.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import PromiseKit

final class QiitaSearchModel {
    weak var output: QiitaSearchModelOutput?
    let request: QiitaItemsAPIRequest
    
    init() {
        request = .init(query: "")
    }
}

extension QiitaSearchModel: QiitaSearchModelInput {
    func firstSearch(query: String) {
        request.query = query
        requestQiitaItems()
    }
    
    func nextSearch() {
        request.incrementPage()
        requestQiitaItems()
    }
}

extension QiitaSearchModel {
    private func requestQiitaItems() {
        APIClient.request(request: self.request).done { [weak self] response in
            guard let `self` = self else { return }
            print(debug: "QiitaItems取得成功!")
            self.output?.searchResult(result: .success(response as! [QiitaItem]))
                
        }
        .catch { [weak self] error in
            guard let `self` = self else { return }
            print(debug: "QiitaItems取得失敗!")
            self.request.decrementPage()
            guard let apiError = error as? APIError else {
                assertionFailure("error is not APIError.")
                return
            }
            self.output?.searchResult(result: .failure(apiError))
        }
    }
}

