//
//  ViewController.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
    
    let request = QiitaItemsAPIRequest(page: 1, query: "Swift")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstly {
            APIClient.isReachable()
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.requestQiitaItems()
        }.catch { error in
            
            guard let networkReachabilityError = error as? NetworkReachabilityError else {
                UIAlertController.showDefaultError(sender: self)
                return
            }
            UIAlertController.show(error: networkReachabilityError, sender: self)
        }
    }
}

extension ViewController {
    
    private func requestQiitaItems() {
        APIClient.request(request: self.request).done { response in
            print(debug: "QiitaItems取得成功!")
        }
        .catch { error in
            print(debug: "QiitaItems取得失敗!")
            guard let apiError = error as? APIError else {
                UIAlertController.showDefaultError(sender: self)
                return
            }
            switch apiError {
                case .others(error: let error):
                    UIAlertController.show(nsError: (error as NSError), sender: self)
                default:
                    UIAlertController.show(error: apiError, sender: self)
            }
        }
    }
}

