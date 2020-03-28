//
//  RealmInitializerForTest.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift
@testable import Swifty

final class RealmInitializerForTest: RealmInitializerCompatible {
    
    let configuration: Realm.Configuration?
    
    init(configuration: Realm.Configuration? = defaultConfiguration()) {
        self.configuration = configuration
    }
    
    static func defaultConfiguration() -> Realm.Configuration {
        let documentsPath =  NSHomeDirectory() + "/Documents"
        let utRealmPath = documentsPath + "/unit_test.realm"
        let configuration = Realm.Configuration(fileURL: utRealmPath.toURL(),
                                                encryptionKey: encryptionKey())
        print("Realm fileURL -> " + configuration.fileURL!.path)
        return configuration
    }
    
    /// 暗号化キーを取得する
    static func encryptionKey() -> Data? {
        let keyString = "ssuMMd3a97IIGbGxF4kLP6y0Vf723qklg8IaIZHEQgUNnb9lE1W1wx4nlLCgQa0p"
        let keyData = keyString.data(using: .utf8)
        print("Realm encryptionKey -> " + keyData!.map { String(format: "%.2hhx", $0) }.joined())
        
        return keyData
    }
    
    func initializeRealm() -> Realm {
        let realm = Realm.sharedRealm(configuration: self.configuration)
        return realm
    }
}

