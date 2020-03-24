//
//  QiitaSearchContract.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - Qiita検索画面のプロトコル定義

/// Presenter -> View
///
/// ビューへの更新依頼を定義
protocol QiitaSearchView: AnyObject {
    func reloadView()
    func showAlert(error: Error)
    func showAlert(nsError: NSError)
}

/// View -> Presenter
///
/// プレゼンターへの処理依頼を定義
protocol QiitaSearchPresentable {
    var dataSource: QiitaSearchViewDataSource { get }
    var isRequesting: Bool { get }
    func tappedSearchButton(query: String)
    func scrollViewIsNearBottomEdge()
    func didSelectRow(indexPath: IndexPath)
}

/// Presenter -> Model
///
/// モデルへの処理依頼を定義
protocol QiitaSearchModelInput: AnyObject {
    var output: QiitaSearchModelOutput? { get set }
    func firstSearch(query: String)
    func nextSearch()
}

/// Model -> Presenter
///
/// プレゼンターへの処理結果通知を定義
protocol QiitaSearchModelOutput: AnyObject {
    func searchResult(result: Swift.Result<[QiitaItem], APIError>)
}

/// Presenter -> Router
///
/// ルーターへの画面遷移依頼を定義
protocol QiitaSearchWireframe {
    func showWebBrowser(urlString: String)
}

