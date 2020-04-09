//
//  ReplyTest.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/09.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

struct ReplyTest: Codable {
    let boardIdx, userIdx: Int
    var content, writer, pw: String
    let ip: String
    let view: Int
    let insDate: String
    let delDate: String?
    let delFlag: String
    let updDate: String?
}
