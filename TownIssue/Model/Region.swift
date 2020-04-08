//
//  Region.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/08.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

//   let region = try? newJSONDecoder().decode(Region.self, from: jsonData)

// MARK: - Region
struct Region: Codable {
    let status: Int?
    let areaIdx, cityIdx: Int
    let cityName: String
    let districtIdx: Int
    let districtName: String
    let townIdx: Int
    let townName: String
    let parentIdx, depth: Int
    let nameKorean, nameEnglish, nameChinese: String
}
