//
//  WebBrowserViewController.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/24.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit
import WebKit

final class WebBrowserViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var presenter: WebBrowserPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        presenter.loadInitialPage()
    }
}

// MARK: - WebBrowserView
extension WebBrowserViewController: WebBrowserView {
    
    func load(urlRequest: URLRequest) {
        showIndicator()
        webView.load(urlRequest)
    }
    
    func showIndicator() {
        startAnimating()
    }
    
    func hideIndicator() {
        stopAnimating()
    }
    
    func showAlert(title: String, message: String) {
        showAlert(title: title, message: message, handler: nil)
    }
}

// MARK: - WKNavigationDelegate (ロード処理)
extension WebBrowserViewController: WKNavigationDelegate {
    
    /// リクエスト開始処理をフック
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            hideIndicator()
            // 読み込みをキャンセル
            decisionHandler(.cancel)
            return
        }
        print(debug: "Request URL: \(url.absoluteString)")
        // 読み込みを許可
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    /// 読み込み開始
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        showIndicator()
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideIndicator()
    }
    
    /// 読み込み中エラー発生
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        presenter.errorOccurredInWebview(error: error)
    }
    
    /// 通信中エラー発生
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        presenter.errorOccurredInWebview(error: error)
    }
}

// MARK: - WKUIDelegate
extension WebBrowserViewController: WKUIDelegate {
    
    /// _blank挙動対応
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard
            let targetFrame = navigationAction.targetFrame,
            targetFrame.isMainFrame else {
                webView.load(navigationAction.request)
                return nil
        }
        return nil
    }
    
    /// プレビュー表示の許可
    func webView(_ webView: WKWebView,
                 shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    /// JavaScriptのAlertを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        hideIndicator()
        showAlert(message: message) { _ in
            completionHandler()
        }
    }
    
    /// JavaScriptのConfirmを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        hideIndicator()
        showConfirm(message: message, positiveHandler: { _ in
            completionHandler(true)
        }) { _ in
            completionHandler(false)
        }
    }
    
    /// JavaScriptのPromptを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        hideIndicator()
        showPrompt(promptMessage: prompt, defaultText: defaultText) { text in
            completionHandler(text)
        }
    }
}

extension WebBrowserViewController: JSAlertCompatible {}

