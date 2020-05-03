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
//    var timeElapsed: String
//    ? {
//        get {
//            let date: Date? = DataUtil.sharedInstance.jsonStringDateToDate(date: insDate)
//            return DataUtil.sharedInstance.timeElapsed(date: date!)
//        }
//    }
}

struct PostCreateResponse: Codable {
    let LAST_INSERT_ID: Int?
}
