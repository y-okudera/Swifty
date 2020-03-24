//
//  WebBrowserContract.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/24.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - Web閲覧画面のプロトコル定義

/// Presenter -> View
///
/// ビューへの更新依頼を定義
protocol WebBrowserView: AnyObject {
    func load(urlRequest: URLRequest)
    func showIndicator()
    func hideIndicator()
    func showAlert(title: String, message: String)
}

/// View -> Presenter
///
/// プレゼンターへの処理依頼を定義
protocol WebBrowserPresentable {
    var initialUrl: URL { get }
    func loadInitialPage()
    func errorOccurredInWebview(error: Error)
}

/// Presenter -> Router
///
/// ルーターへの画面遷移依頼を定義
protocol WebBrowserWireframe {
    
}

