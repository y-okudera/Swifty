//
//  WebBrowserPresenter.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/24.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

final class WebBrowserPresenter {
    
    private weak var view: WebBrowserView?
    private let router: WebBrowserWireframe
    let initialUrl: URL
    
    init(view: WebBrowserView, router: WebBrowserWireframe, initialUrl: URL) {
        self.view = view
        self.router = router
        self.initialUrl = initialUrl
    }
}

extension WebBrowserPresenter: WebBrowserPresentable {
    
    func loadInitialPage() {
        print(debug: "initialUrl", initialUrl.absoluteString)
        let request = URLRequest(url: initialUrl)
        view?.load(urlRequest: request)
    }
    
    func errorOccurredInWebview(error: Error) {
        print(debug: "WebView Error", error)
        view?.hideIndicator()
        
        guard let urlError = error as? URLError else {
            return
        }
        let isOffline = urlError.code == URLError.notConnectedToInternet
        let isTimeout = urlError.code == URLError.timedOut
        if isOffline || isTimeout {
            view?.showAlert(title: "Error".localized(),
                            message: "ConnectionError".localized())
        }
    }
}

