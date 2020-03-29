//
//  AuthenticationSession.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/29.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import AuthenticationServices
import SafariServices

protocol AuthenticationSessionDelegate: AnyObject {
    func authenticationSession(_ authenticationSession: AuthenticationSession, authenticated url: URL)
    func authenticationCanceled(in authenticationSession: AuthenticationSession)
    func authenticationSession(_ authenticationSession: AuthenticationSession, failed error: Error?)
}

final class AuthenticationSession {
    
    private weak var delegate: AuthenticationSessionDelegate?
    
    private var authenticationUrl: URL
    private var callbackURLScheme: String?
    private var authenticationSession: Any?
    private var presentationContextProvider: Any?
    
    init(authenticationUrl: URL, callbackURLScheme: String? = nil, delegate: AuthenticationSessionDelegate) {
        self.authenticationUrl = authenticationUrl
        self.callbackURLScheme = callbackURLScheme
        self.delegate = delegate
    }
    
    func authenticationStart(from viewController: UIViewController) {
        if #available(iOS 12.0, *) {
            let authenticationSession = ASWebAuthenticationSession(
                url: authenticationUrl,
                callbackURLScheme: callbackURLScheme,
                completionHandler: authenticateCompletionHandler(url:error:))
            if #available(iOS 13.0, *) {
                let presentationContextProvider = AuthPresentationContextProvider(viewController: viewController)
                authenticationSession.presentationContextProvider = presentationContextProvider
                self.presentationContextProvider = presentationContextProvider
            }
            authenticationSession.start()
            self.authenticationSession = authenticationSession
            
        } else {
            let authenticationSession = SFAuthenticationSession(
                url: authenticationUrl,
                callbackURLScheme: callbackURLScheme,
                completionHandler: authenticateCompletionHandler(url:error:))
            authenticationSession.start()
            self.authenticationSession = authenticationSession
        }
    }
    
    private func authenticateCompletionHandler(url: URL?, error: Error?) {
        defer {
            authenticationSession = nil
            presentationContextProvider = nil
        }
        
        if let url = url {
            print(debug: "the authentication session is completed successfully", "url:", url.absoluteString)
            delegate?.authenticationSession(self, authenticated: url)
            return
        }
        
        guard let error = error else {
            delegate?.authenticationSession(self, failed: nil)
            return
        }
        print(debug: "the authentication session has error:", error.localizedDescription)
        
        let nsError = (error as NSError)
        if #available(iOS 12.0, *) {
            if nsError.domain == ASWebAuthenticationSessionErrorDomain
                && nsError.code == ASWebAuthenticationSessionError.Code.canceledLogin.rawValue {
                delegate?.authenticationCanceled(in: self)
                return
            }
        } else {
            if nsError.domain == SFAuthenticationErrorDomain
                && nsError.code == SFAuthenticationError.Code.canceledLogin.rawValue {
                delegate?.authenticationCanceled(in: self)
                return
            }
        }
        delegate?.authenticationSession(self, failed: error)
    }
}

@available(iOS 13.0, *)
private class AuthPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return viewController.view.window!
    }
}

