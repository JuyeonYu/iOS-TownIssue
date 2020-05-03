//
//  PostViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class PostViewModel {
    let areaIdx: Int
    let view: Int
    let boardIdx: Int
    let writer: String
    let title: String
    let content: String
    let ip: String
    var timeElapsed: String
    
    init(post: Post) {
        areaIdx = post.areaIdx
        view = post.view
        boardIdx = post.boardIdx
        writer = post.writer
        title = post.title
        content = post.content
        ip = post.ip
        timeElapsed = DataUtil.sharedInstance.timeElapsed(date: DataUtil.sharedInstance.jsonStringDateToDate(date: post.insDate)!)
    }
}
