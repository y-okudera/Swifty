//
//  RealmInitializerCompatible.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmInitializerCompatible {
    var configuration: Realm.Configuration? { get }
    
    static func defaultConfiguration() -> Realm.Configuration
    static func encryptionKey() -> Data?
    func initializeRealm() -> Realm
}

