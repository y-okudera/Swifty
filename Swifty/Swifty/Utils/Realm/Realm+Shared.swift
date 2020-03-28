//
//  Realm+Shared.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

/// スレッドごとに1インスタンスを生成する(そのスレッドに既にキャッシュがあれば、それを返す)
///
/// - Parameters:
///   - key: オブジェクトのID
///   - create: スレッドで初めてオブジェクトを生成するときの処理
/// - Returns: 呼び出し元スレッドのオブジェクトのインスタンス
private func threadSharedRealmObject(key: String, create: () -> Realm) -> Realm {
    if let cachedObj = Thread.current.threadDictionary[key] as? Realm {
        return cachedObj
    }
    let newObject = create()
    Thread.current.threadDictionary[key] = newObject
    return newObject
}

extension Realm {
    
    /// ローカルスレッド共有Realm
    ///
    /// - Returns: Realmのインスタンス
    static func sharedRealm(configuration: Realm.Configuration? = RealmInitializer.defaultConfiguration()) -> Realm {
        let name = Bundle.main.bundleIdentifier! + String(describing: type(of: Realm.self))
        let realm = threadSharedRealmObject(key: name) {
            print(debug: Thread.current, "新規Realmインスタンス")
            
            do {
                if let configuration = configuration {
                    return try Realm(configuration: configuration)
                } else {
                    return try Realm()
                }
                
            } catch {
                fatalError("Realm initialize error: \(error)")
            }
        }
        return realm
    }
}

