//
//  DataUtil.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import NetworkExtension


class DataUtil {
    static let sharedInstance = DataUtil()

    init() {}
    
    func jsonStringDateToDate(date: String) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: date)!
        return date
    }
    
    func timeElapsed(date: Date) -> String {

        let date1:Date = date
        let date2: Date = Date() // Same you did before with timeNow variable

        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        var returnString:String = ""

        if components.second! < 60 {
            returnString = NSLocalizedString("Just Now", comment: "")
        }

        if components.minute! > 1 {
            returnString = String(describing: components.minute!) + NSLocalizedString("mins ago", comment: "")
        } else if components.minute! == 1 {
            returnString = String(NSLocalizedString("A minute ago", comment: ""))
        }

        if components.hour! > 1 {
            returnString = String(describing: components.hour!) + NSLocalizedString("hours ago", comment: "")
        } else if components.hour == 1 {
            returnString = NSLocalizedString("An hour ago", comment: "")
        }

        if components.day! > 1 {
            returnString = String(describing: components.day!) + NSLocalizedString("days ago", comment: "")
        } else if components.day! == 1 {
            returnString = NSLocalizedString("Yesterday", comment: "")
        }

        if components.month! > 1{
            returnString = String(describing: components.month!) + NSLocalizedString("months ago", comment: "")
        } else if components.month! == 1 {
            returnString = NSLocalizedString("A month ago", comment: "")
        }

        if components.year! > 1 {
            returnString = String(describing: components.year!) + NSLocalizedString("years ago", comment: "")
        }
        else if components.year! == 1 {
            returnString = NSLocalizedString("A year ago", comment: "")
        }

        return returnString
    }
    
    func realmRegionsToRegions (realmRegions: [RealmRegion]) -> [Region] {
        var regions: Array<Region> = []
        
        for region in realmRegions {
            regions.append(Region(status: nil,
                                areaIdx: region.areaIdx,
                                cityIdx: 0, cityName: "",
                                districtIdx: 0,
                                districtName: "",
                                townIdx: 0,
                                townName: "",
                                parentIdx: 0,
                                depth: 0,
                                nameKorean: region.nameKorean,
                                nameEnglish: "",
                                nameChinese: ""))
        }
        
        return regions
    }
    
    func realmPostToPost (realmPost: RealmPost) -> Post {
        return Post(areaIdx: 0,
                    view: realmPost.view,
                    insDate: realmPost.insDate,
                    boardIdx: realmPost.boardIdx,
                    writer: realmPost.writer,
                    title: realmPost.title,
                    content: realmPost.content,
                    ip: realmPost.ip,
                    pw: nil)
    }
}
