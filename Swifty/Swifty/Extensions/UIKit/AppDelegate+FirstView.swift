//
//  AppDelegate+FirstView.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    /// アプリ起動後、最初に表示する画面を設定する
    ///
    /// - Parameters:
    ///   - viewController: 最初に表示する画面のViewController
    ///   - includeNavigationController: NavigationControllerを含めるかどうか
    func firstView(viewController: UIViewController, includeNavigationController: Bool = false) {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if includeNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = viewController
        }
        window?.makeKeyAndVisible()
    }
}

