// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reply = try? newJSONDecoder().decode(Reply.self, from: jsonData)

import Foundation

// MARK: - Reply

struct Reply: Codable {
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
}
