//
//  Network.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import Alamofire

struct Network {
    struct Urls {
        static let baseURL: String =                "http://townissue.com:9080"
        
        // 지역
        static let readRegionsWithDepth =           "/api/area/custom/depth"
        static let readRegionsWithParentIndex =     "/api/area/custom/parentIdx"

        // 글
        static let createPost =                      "/api/board/service"
        static let readPostWithAreaIndex =          "/api/board/service/area"
        static let readPostWithBoardIndex =       "/api/board/service"
        static let updatePostWithBoardIndex =       "/api/board/service"
        static let deletePostWithBoardIndex =       "/api/board/service"
        static let checkPostPasswordWithBoardIndex = "/api/board/service/chk"
        
        

        // 댓글
        static let createReply =                         "/api/comment/service"
        static let readReplyWithboardIndex =            "/api/comment/service/board"
        static let updateReplywithCommnetIndex =        "/api/comment/service"
        static let deleteReplyWithCommnetIndex =        "/api/comment/service"
        static let checkReplyPasswordWithCommnetIndex = "/api/comment/service/chk"

        
        
    }
    
//    static let HTTPHeader: HTTPHeaders = ["Content-Type":"application/json"]
    
//    static let  headers: HTTPHeaders = ["Content-Type":"application/json", "Accept": "application/json"]

    static let kAPI: String = "api"
    static let kBoard: String = "board"
    static let kArea: String = "area"
    static let kCommon: String = "common"
    static let kService: String = "service"
    static let kCustom: String = "custom"
    
    static let kPost: String = "post"
    static let kRegionCode: String = "region_code"
    static let kIndex: String = "index"
    static let kBoardIndex: String = "boardIdx"
    
    
    static let kRegion: String = "region"
    static let kDepth: String = "depth"
    static let kDepth1: String = "1"
    
    static let kTitle: String = "title"
    static let kContent: String = "content"
    
    static let kWriter: String = "writer"
    static let kPassword: String = "pw"
    
    static let kAreaIndex: String = "areaIdx"
    static let kUserIndex: String = "userIdx"
    static let kParentIndex: String = "parentIdx"
    
    static let kIP: String = "ip"
    static let kSize: String = "size"
    static let kSort: String = "sort"
    static let kInsDate: String = "insDate"
    static let kBoardIdx: String = "boardIdx"
    static let kPagingSize: Int = 20
    
    static let kSuccessDeletePost: Int = 1
    static let kFailDeletePost: Int = 0
}
