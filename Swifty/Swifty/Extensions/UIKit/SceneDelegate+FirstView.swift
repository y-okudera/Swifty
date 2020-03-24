//
//  SceneDelegate+FirstView.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

@available(iOS 13, *)
extension SceneDelegate {
    
    /// アプリ起動後、最初に表示する画面を設定する
    ///
    /// - Parameters:
    ///   - scene: UIScene
    ///   - viewController: 最初に表示する画面のViewController
    ///   - includeNavigationController: NavigationControllerを含めるかどうか
    func firstView(scene: UIScene, viewController: UIViewController, includeNavigationController: Bool = false) {
        
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: scene)
        
        
        if includeNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
        } else {
            window.rootViewController = viewController
        }
        self.window = window
        window.makeKeyAndVisible()
    }
}

