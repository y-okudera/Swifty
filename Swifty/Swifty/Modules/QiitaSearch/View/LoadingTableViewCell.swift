//
//  LoadingTableViewCell.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13, *) {
                activityIndicatorView.style = .medium
            } else {
                activityIndicatorView.style = .gray
            }
        }
    }
    
    func startAnimating() {
        if activityIndicatorView.isAnimating {
            return
        }
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.stopAnimating()
        }
    }
}

extension LoadingTableViewCell: TableViewNibRegistrable {}

