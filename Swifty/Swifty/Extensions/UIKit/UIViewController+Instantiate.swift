//
//  UIViewController+Instantiate.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// StoryboardからViewControllerのインスタンスを生成する
    ///
    /// - Precondition: ViewControllerクラスの名称とStoryboardのファイル名、Storyboard IDが同じである前提
    ///
    /// - Note: ex) LoginViewController.swift, LoginViewController.storyboard, Storyboard ID: LoginViewController
    class func instantiate<T: UIViewController>() -> T {
        let viewControllerName = String(describing: T.self)
        let viewController: T = .instantiate(storyboardName: viewControllerName, identifier: viewControllerName)
        return viewController
    }
    
    class func instantiate<T: UIViewController>(storyboardName: String, identifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: T.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Failed to instantiate \(identifier). storyboardName is \(storyboardName).")
        }
        return viewController
    }
}

