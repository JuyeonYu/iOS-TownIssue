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
    static let baseURL: String = "http://townissue.com:9080"
//    static let HTTPHeader: HTTPHeaders = ["Content-Type":"application/json"]
    
//    static let  headers: HTTPHeaders = ["Content-Type":"application/json", "Accept": "application/json"]

    static let kAPI: String = "api"
    static let kBoard: String = "board"
    static let kArea: String = "area"
    static let kCommon: String = "common"
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
    
    static let kSuccessDeletePost: Int = 1
    static let kFailDeletePost: Int = 0
}
