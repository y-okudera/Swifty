//
//  String+ToURL.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

extension String {
    func toURL() -> URL {
        guard let url = URL(string: self) else {
            fatalError("URL failed to instantiate from string.")
        }
        return url
    }
}

