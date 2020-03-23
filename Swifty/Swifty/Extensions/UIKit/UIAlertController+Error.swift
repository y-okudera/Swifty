//
//  UIAlertController+Error.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showDefaultError(sender: UIViewController) {
        let alert = UIAlertController(title: "Error".localized(),
                                      message: "DefaultErrorMessage".localized(),
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK".localized(), style: .default))
        sender.present(alert, animated: true)
    }
    
    /// Show alert with Error object.
    class func show(error: Error, sender: UIViewController) {
        let alert = UIAlertController(title: "Error".localized(),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK".localized(), style: .default))
        sender.present(alert, animated: true)
    }
    
    /// Show alert with NSError object.
    class func show(nsError: NSError, sender: UIViewController) {
        var title = "Error".localized()
        var errorMessage = "DefaultErrorMessage".localized()
        var btnTitle = "OK".localized()
        
        if let localizedFailureReason = nsError.localizedFailureReason {
            errorMessage = localizedFailureReason
        } else if !nsError.localizedDescription.isEmpty {
            errorMessage = nsError.localizedDescription
        }
        
        if let suggestion = nsError.localizedRecoverySuggestion {
            title = suggestion
        }
        
        if let recoveryOptions = nsError.localizedRecoveryOptions {
            if !recoveryOptions.isEmpty {
                btnTitle = recoveryOptions[0]
            }
        }
        
        let alert = UIAlertController(title: title,
                                      message: errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: btnTitle, style: .default))
        sender.present(alert, animated: true)
    }
}

