//
//  QiitaSearchRouter.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class QiitaSearchRouter {
    
    private weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    class func assembleModules() -> UIViewController {
        
        let qiitaSearchView: QiitaSearchViewController = .instantiate()
        let qiitaSearchModel: QiitaSearchModelInput = QiitaSearchModel()
        let router = QiitaSearchRouter(viewController: qiitaSearchView)
        let presenter = QiitaSearchViewPresenter(view: qiitaSearchView,
                                                 model: qiitaSearchModel,
                                                 router: router)
        
        qiitaSearchView.presenter = presenter
        qiitaSearchModel.output = presenter
        
        return qiitaSearchView
    }
}

extension QiitaSearchRouter: QiitaSearchWireframe {
    
    func showUserGitHubPageBrowse() {
        // TODO: - GitHubPageを表示するWebView実装後対応
    }
    
    func showItemPageBrowse() {
        // TODO: - Qiitaの記事を表示するWebView実装後対応
    }
    
    
}

