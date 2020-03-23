//
//  DateFormatter+Shared.swift
//  Swifty
//
//  Created by Yuki Okudera on 2019/08/19.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

/// スレッドごとに1インスタンスを生成する(そのスレッドに既にキャッシュがあれば、それを返す)
///
/// - Parameters:
///   - key: オブジェクトのID
///   - create: スレッドで初めてオブジェクトを生成するときの処理
/// - Returns: 呼び出し元スレッドのオブジェクトのインスタンス
fileprivate func threadSharedObject<T: AnyObject>(key: String, create: () -> T) -> T {
    if let cachedObj = Thread.current.threadDictionary[key] as? T {
        return cachedObj
    }
    let newObject = create()
    Thread.current.threadDictionary[key] = newObject
    return newObject
}

extension DateFormatter {

    /// ローカルスレッド共有DateFormatter
    ///
    /// - Returns: DateFormatterのインスタンス
    static func sharedFormatter() -> DateFormatter {
        let name = Bundle.main.bundleIdentifier! + String(describing: type(of: DateFormatter.self))
        let dateFormatter: DateFormatter = threadSharedObject(key: name) {
            return DateFormatter()
        }
        dateFormatter.dateFormat = ""
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.calendar = .current
        return dateFormatter
    }
}

