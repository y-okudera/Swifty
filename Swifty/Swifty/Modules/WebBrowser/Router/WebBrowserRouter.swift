//
//  WebBrowserRouter.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/24.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class WebBrowserRouter {
    
    private weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    class func assembleModules(urlString: String) -> UIViewController {
        
        let initialUrl = urlString.toURL()
        let webBrowserView: WebBrowserViewController = .instantiate()
        let router = WebBrowserRouter(viewController: webBrowserView)
        let presenter = WebBrowserPresenter(view: webBrowserView, router: router, initialUrl: initialUrl)
        
        webBrowserView.presenter = presenter
        
        return webBrowserView
    }
}

extension WebBrowserRouter: WebBrowserWireframe {
}

