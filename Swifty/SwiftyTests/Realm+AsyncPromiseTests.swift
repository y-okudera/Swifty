//
//  Realm+AsyncPromiseTests.swift
//  SwiftyTests
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import XCTest
import PromiseKit
import RealmSwift
@testable import Swifty

final class Realm_AsyncPromiseTests: XCTestCase {
    
    let dao = RealmDaoHelper<GeneratedEntity>(realmInitializer: RealmInitializerForTest())
    
    let writeDataExpectation = XCTestExpectation(description: "Realm 非同期 書き込みテスト")
    let readDataExpectation = XCTestExpectation(description: "Realm 非同期 読み込みテスト")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try! dao.deleteAll()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWriteAndReadAsyncRealm() {
            // Setup
            let jsonName = "light_generated.json"
            let stubDataReader = JSONFileReader(jsonFileName: jsonName, decodeType: [Generated].self)
            
            stubDataReader.decode { result in
                switch result {
                    case .success(let stubData):
                        let entities = stubData.map { return GeneratedEntity(generated: $0) }
                        // Execute async write
                        asyncWriteGeneratedEntities(entities)
                    
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                }
            }
            self.wait(for: [writeDataExpectation, readDataExpectation], timeout: 360.0)
    }
    
    private func asyncWriteGeneratedEntities(_ entities: [GeneratedEntity]) {
        
        dao.realm.writeAsync(configuration: dao.configuration(), objects: entities).done { [weak self] in
            guard let `self` = self else { return }
            self.writeDataExpectation.fulfill()
            // Execute async read
            self.asyncReadGeneratedEntities()
        }
        .catch { error in
            XCTFail(error.localizedDescription)
        }
    }
    
    private func asyncReadGeneratedEntities() {
        
        Realm.readAsync(configuration: dao.configuration()).done(on: .realmQueue) { [weak self] realm in
            guard let `self` = self else { return }
            let data = realm.objects(GeneratedEntity.self)
            
            // Verify
            XCTAssertEqual(data.count, 30)
            
            XCTAssertEqual(data[0].id, 0)
            XCTAssertEqual(data[0].title, "tempor")
            XCTAssertEqual(data[0].guid, "74caee83-0c89-4161-afbc-d1dba6ebb71a")
            XCTAssertEqual(data[0].picture, "http://placehold.it/32x32")
            XCTAssertEqual(data[0].age, 39)
            XCTAssertEqual(data[0].name, "Roberta Wise")
            XCTAssertEqual(data[0].tags.count, 7)
            XCTAssertEqual(data[0].tags[0], "non")
            XCTAssertEqual(data[0].tags[1], "ipsum")
            XCTAssertEqual(data[0].tags[2], "et")
            XCTAssertEqual(data[0].tags[3], "ut")
            XCTAssertEqual(data[0].tags[4], "duis")
            XCTAssertEqual(data[0].tags[5], "quis")
            XCTAssertEqual(data[0].tags[6], "aute")
            
            self.readDataExpectation.fulfill()
        }
        .catch { error in
            XCTFail(error.localizedDescription)
        }
    }
}

