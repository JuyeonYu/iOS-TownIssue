//
//  Region.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/08.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import RealmSwift
//   let region = try? newJSONDecoder().decode(Region.self, from: jsonData)

// MARK: - Region
struct Region: Codable {
    let status: String?
    let areaIdx: Int
    let cityIdx: Int
    let cityName: String
    let districtIdx: Int
    let districtName: String
    let townIdx: Int
    let townName: String
    let parentIdx: Int
    let depth: Int
    let nameKorean: String
    let nameEnglish: String
    let nameChinese: String
}

class RealmRegion: Object {
    @objc dynamic var areaIdx = 0
    @objc dynamic var nameKorean = ""
}
