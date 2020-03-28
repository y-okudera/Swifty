//
//  Realm+Async.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import PromiseKit
import RealmSwift

extension DispatchQueue {
    static let realmQueue: DispatchQueue = {
        let queueName = Bundle.main.bundleIdentifier! + ".realm.bg"
        let queue = DispatchQueue(label: queueName)
        return queue
    }()
}

extension Realm {
    
    typealias ErrorHandler = (_ error : Swift.Error) -> Void
    
    /// 非同期でレコードを取得する
    /// - Parameters:
    ///   - configuration: Realm.Configuration
    ///   - backgroundBlock: バックグラウンドスレッドで実行する処理
    ///   - errorHandler: Realmを開く際のerrorHandler
    static func readAsync(configuration: Realm.Configuration,
                          backgroundBlock: @escaping ((Realm) -> Void),
                          errorHandler: @escaping ErrorHandler = { _ in return }) {
        Realm.asyncOpen(configuration: configuration, callbackQueue: .realmQueue) { realm, error in
            if let realm = realm {
                // Realm successfully opened, with migration applied on background thread
                backgroundBlock(realm)
            } else if let error = error {
                // Handle error that occurred while opening the Realm
                errorHandler(error)
            }
        }
    }
    
    /// 非同期でレコードを書き込む
    /// - Parameters:
    ///   - configuration: Realm.Configuration
    ///   - objects: RealmSwift.ObjectのArray
    ///   - writeCompletionOnMain: 書き込み完了後のHandler
    ///   - errorHandler: 書き込み時のerrorHandler
    func writeAsync<T: RealmSwift.Object>(configuration: Realm.Configuration,
                                          objects: [T],
                                          writeCompletionOnMain: @escaping (() -> Void),
                                          errorHandler: @escaping ErrorHandler = { _ in return }) {
        DispatchQueue.realmQueue.async {
            let realm = Realm.sharedRealm(configuration: configuration)
            if realm.isInWriteTransaction {
                realm.add(objects)
            } else {
                do {
                    try realm.write {
                        realm.add(objects)
                    }
                } catch {
                    errorHandler(error)
                }
            }
            
            DispatchQueue.main.async {
                writeCompletionOnMain()
            }
        }
    }
}

// MARK: - Promise

extension Realm {
    
    /// 非同期でレコードを取得する
    /// - Parameter configuration: Realm.Configuration
    static func readAsync(configuration: Realm.Configuration) -> Promise<Realm> {
        
        return Promise<Realm> { resolver in
            Realm.asyncOpen(configuration: configuration, callbackQueue: .realmQueue) { realm, error in
                if let realm = realm {
                    // Realm successfully opened, with migration applied on background thread
                    resolver.fulfill(realm)
                } else if let error = error {
                    // Handle error that occurred while opening the Realm
                    resolver.reject(error)
                }
            }
        }
    }
    
    /// 非同期でレコードを書き込む
    /// - Parameters:
    ///   - configuration: Realm.Configuration
    ///   - objects: RealmSwift.ObjectのArray
    func writeAsync<T: RealmSwift.Object>(configuration: Realm.Configuration,
                                          objects: [T]) -> Promise<Void> {
        return Promise<Void> { resolver in
            DispatchQueue.realmQueue.async {
                let realm = Realm.sharedRealm(configuration: configuration)
                if realm.isInWriteTransaction {
                    realm.add(objects)
                } else {
                    do {
                        try realm.write {
                            realm.add(objects)
                        }
                    } catch {
                        resolver.reject(error)
                    }
                }
                
                DispatchQueue.main.async {
                    resolver.fulfill(())
                }
            }
        }
    }
}

