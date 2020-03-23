//
//  UITraitCollection+IsDarkMode.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

extension UITraitCollection {
    static var isDarkMode: Bool {
        if #available(iOS 13, *), current.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
}

