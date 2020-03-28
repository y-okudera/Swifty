//
//  GeneratedEntity.swift
//  SwiftyTests
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

final class GeneratedEntity: RealmSwift.Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var guid = ""
    @objc dynamic var picture = ""
    @objc dynamic var age = 0
    @objc dynamic var name = ""
    let tags = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(generated: Generated) {
        self.init()
        self.id = generated.id
        self.title = generated.title
        self.guid = generated.guid
        self.picture = generated.picture
        self.age = generated.age
        self.name = generated.name
        self.tags.append(objectsIn: generated.tags)
    }
}

