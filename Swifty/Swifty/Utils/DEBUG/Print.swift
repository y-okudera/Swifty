//
//  Print.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/22.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

func print(debug: Any..., function: String = #function, file: String = #file, line: Int = #line) {
    #if DEBUG
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    Swift.print("[File: \(filename), Line: \(line), Func: \(function)] \(debug)")
    #endif
}

func dump<T>(debug: T) {
    #if DEBUG
    Swift.dump(debug)
    #endif
}

