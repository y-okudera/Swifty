//
//  UIImageView+Nuke.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Nuke
import UIKit

extension UIImageView {
    func setImageByNuke(url: URL) {
        let options = ImageLoadingOptions(
            transition: .fadeIn(duration: 0.25)
        )
        Nuke.loadImage(with: url, options: options, into: self)
    }
}

