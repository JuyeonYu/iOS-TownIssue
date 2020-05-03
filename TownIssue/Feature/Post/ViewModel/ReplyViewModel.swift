//
//  ReplyViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/30.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class ReplyViewModel {
    let depth: Int
    let insDate: String
    let parentIdx: Int
    let boardIdx: Int
    let userIdx: Int
    let commentIdx: Int
    let writer: String
    let content: String
    let order: Int
    let ip: String
    var timeElapsed: String
    
    init(reply: Reply) {
        depth = reply.depth
        insDate = reply.insDate
        parentIdx = reply.parentIdx
        boardIdx = reply.boardIdx
        userIdx = reply.userIdx
        commentIdx = reply.commentIdx
        writer = reply.writer
        content = reply.content
        order = reply.order
        ip = reply.ip
        timeElapsed = DataUtil.sharedInstance.timeElapsed(date: DataUtil.sharedInstance.jsonStringDateToDate(date: reply.insDate)!)
    }
}
