//
//  PostEditViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class PostEditViewModel {
    var title: String
    var writer: String
    var password: String
    var textContent: String
    
    struct Section {
        let post: [Post]
    }
    
    init(post: Post) {
        title = post.title
        writer = post.writer
        password = post.pw
        textContent = post.content
        
    }
}
