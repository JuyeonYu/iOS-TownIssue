//
//  PostViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class PostViewModel {
    let title, content, writer: String
    let ip: String
    let view: Int
    let insDate: String
    
    init(post: Post) {
        title = post.title
        content = post.content
        writer = post.writer
        ip = post.ip
        view = post.view
        insDate = post.insDate
    }
}
