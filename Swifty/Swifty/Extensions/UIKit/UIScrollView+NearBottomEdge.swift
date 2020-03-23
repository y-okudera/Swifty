//
//  UIScrollView+NearBottomEdge.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        if contentSize.height <= 0 {
            return false
        }
        return contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }
}

