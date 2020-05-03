//
//  PostEditViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class PostEditViewModel {
    let areaIdx: Int
    let view: Int
    let insDate: String
    let boardIdx: Int
    let writer: String
    let title: String
    let content: String
    
    init(post: Post) {
        areaIdx = post.areaIdx
        view = post.view
        insDate = post.insDate
        boardIdx = post.boardIdx
        writer = post.writer
        title = post.title
        content = post.content
    }
}
