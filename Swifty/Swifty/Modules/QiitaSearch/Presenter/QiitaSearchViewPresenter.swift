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
    
    lazy var dataSource: QiitaSearchViewDataSource = {
        let dataSource = QiitaSearchViewDataSource(qiitaSearchCelldelegate: self)
        return dataSource
    }()
    
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
    
    func didSelectRow(indexPath: IndexPath) {
        guard let urlString = dataSource.qiitaItems[indexPath.row].url else {
            return
        }
        router.showWebBrowser(urlString: urlString)
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

extension QiitaSearchViewPresenter: QiitaSearchTableViewCellDelegate {
    func didTapUserIcon(indexPath: IndexPath) {
        guard let urlString = dataSource.qiitaItems[indexPath.row].makeQiitaUserUrlString() else {
            return
        }
        router.showWebBrowser(urlString: urlString)
    }
    
    func didTapGitHubIcon(indexPath: IndexPath) {
        guard let urlString = dataSource.qiitaItems[indexPath.row].makeGitHubUserUrlString() else {
            return
        }
        router.showWebBrowser(urlString: urlString)
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
            case .cancelled:
                print(debug: "QiitaItems取得キャンセル")
                return
            case .others(error: let error):
                print(debug: "QiitaItems取得失敗!")
                view?.showAlert(nsError: (error as NSError))
            
            default:
                print(debug: "QiitaItems取得失敗!")
                view?.showAlert(error: apiError)
        }
    }
}

