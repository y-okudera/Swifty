//
//  QiitaItemsAPIResponse.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/21.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

struct QiitaItem: Decodable {
    var id: String?
    var title: String?
    var url: String?
    var createdAt: String?
    var updatedAt: String?
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var `private`: Bool = false
    var tags: [QiitaItemTag] = []
    var user: QiitaUser?
}

struct QiitaItemTag: Decodable {
    var name: String?
    var versions: [String] = []
}

struct QiitaUser: Decodable {
    var followersCount: Int = 0
    var githubLoginName: String?
    var id: String?
    var profileImageUrl: String?
    var teamOnly: Bool = false
}

struct QiitaItemsAPIErrorResponse: Decodable {
    var message: String?
    var type: String?
}

