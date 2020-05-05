//
//  Post.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let post = try? newJSONDecoder().decode(Post.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let post = try? newJSONDecoder().decode(Post.self, from: jsonData)

import Foundation
import RealmSwift

// MARK: - Post
struct Post: Codable {
    let areaIdx: Int
    var view: Int
    let insDate: String
    let boardIdx: Int
    var writer: String
    var title: String
    var content: String
    let ip: String
    var pw: String?
}

struct PostCreateResponse: Codable {
    let LAST_INSERT_ID: Int?
}

class RealmPost: Object {
    @objc dynamic var boardIdx = 0
    @objc dynamic var writer = ""
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var ip = ""
    @objc dynamic var view = 0
    @objc dynamic var insDate = ""
}
