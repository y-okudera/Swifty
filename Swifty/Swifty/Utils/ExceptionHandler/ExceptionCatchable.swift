//
//  ExceptionCatchable.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

protocol ExceptionCatchable {}

extension ExceptionCatchable {
    func execute(_ tryBlock: () -> ()) throws {
        try ExceptionHandler.catchException(try: tryBlock)
    }
}

