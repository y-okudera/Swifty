//
//  JSAlertCompatible.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/24.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit
import WebKit

protocol JSAlertCompatible where Self: UIViewController {
    
    var webView: WKWebView! { get }
    
    /// OKボタンのみのアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - handler: OKボタンタップ後の処理
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?)
    
    /// OK/Cancelボタンを持つアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - positiveHandler: OKボタンタップ後の処理
    ///   - negativeHandler: Cancelボタンタップ後の処理
    func showConfirm(title: String, message: String,
                     positiveHandler: ((UIAlertAction) -> Void)?,
                     negativeHandler: ((UIAlertAction) -> Void)?)
    
    /// TextFieldを持つアラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - promptMessage: アラートのメッセージ
    ///   - defaultText: デフォルト入力文字列
    ///   - completionHandler: OK/Cancelボタンタップ後の処理
    func showPrompt(title: String,
                    promptMessage: String,
                    defaultText: String?,
                    completionHandler: @escaping (String) -> Void)
}

extension JSAlertCompatible {
    
    func showAlert(title: String = "",
                   message: String,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            .init(title: "OK".localized(), style: .default, handler: handler)
        )
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirm(title: String = "",
                     message: String,
                     positiveHandler: ((UIAlertAction) -> Void)? = nil,
                     negativeHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            .init(title: "OK".localized(), style: .default, handler: positiveHandler)
        )
        alert.addAction(
            .init(title: "Cancel".localized(), style: .cancel, handler: negativeHandler)
        )
        present(alert, animated: true, completion: nil)
    }
    
    func showPrompt(title: String = "",
                    promptMessage: String,
                    defaultText: String?,
                    completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: promptMessage, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = defaultText
        }
        alert.addAction(
            UIAlertAction(title: "OK".localized(), style: .default, handler: { _ in
                completionHandler(alert.textFields?.first?.text ?? "")
            })
        )
        alert.addAction(
            UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { _ in
                completionHandler("")
            })
        )
        present(alert, animated: true, completion: nil)
    }
}

