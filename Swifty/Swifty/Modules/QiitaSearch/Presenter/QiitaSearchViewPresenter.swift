//
//  QiitaSearchViewPresenter.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import PromiseKit

final class QiitaSearchViewPresenter {
    
    private weak var view: QiitaSearchView?
    private let model: QiitaSearchModelInput
    private let router: QiitaSearchWireframe
    
    private(set) var dataSource = QiitaSearchViewDataSource()
    private(set) var isRequesting: Bool = false {
        didSet {
            if isRequesting {
                dataSource.startLoading()
            } else {
                dataSource.stopLoading()
            }
            view?.reloadView()
        }
    }
    
    init(view: QiitaSearchView, model: QiitaSearchModelInput, router: QiitaSearchWireframe) {
        self.view = view
        self.model = model
        self.router = router
    }
}

extension QiitaSearchViewPresenter: QiitaSearchPresentable {
    func tappedSearchButton(query: String) {
        setQiitaItems(newItems: [])
        isRequesting = true
        checkNetworkReachabilityStatus { [weak self] in
            guard let `self` = self else { return }
            self.model.firstSearch(query: query)
        }
    }
    
    func scrollViewIsNearBottomEdge() {
        isRequesting = true
        checkNetworkReachabilityStatus { [weak self] in
            guard let `self` = self else { return }
            self.model.nextSearch()
        }
    }
    
    /// ネットワーク状態をチェックし、Qiitaの記事一覧を取得する
    private func checkNetworkReachabilityStatus(requestQiitaItems: @escaping () -> Void) {
        firstly {
            APIClient.isReachable()
        }
        .done {
            requestQiitaItems()
        }
        .catch { [weak self] error in
            guard let `self` = self else { return }
            self.isRequesting = false
            
            guard let networkReachabilityError = error as? NetworkReachabilityError else {
                assertionFailure("error is not NetworkReachabilityError.")
                return
            }
            self.view?.showAlert(error: networkReachabilityError)
        }
    }
    
    private func setQiitaItems(newItems: [QiitaItem]) {
        dataSource.set(newItems: newItems)
        view?.reloadView()
    }
    
    private func appendQiitaItems(additionalItems: [QiitaItem]) {
        dataSource.append(additionalItems: additionalItems)
        view?.reloadView()
    }
}

extension QiitaSearchViewPresenter: QiitaSearchModelOutput {
    func searchResult(result: Swift.Result<[QiitaItem], APIError>) {
        isRequesting = false
        
        switch result {
            case .success(let response):
                appendQiitaItems(additionalItems: response)
            
            case .failure(let apiError):
                handleAPIError(apiError: apiError)
        }
    }
    
    private func handleAPIError(apiError: APIError) {
        switch apiError {
            case .others(error: let error):
                view?.showAlert(nsError: (error as NSError))
            
            default:
                view?.showAlert(error: apiError)
        }
    }
}
