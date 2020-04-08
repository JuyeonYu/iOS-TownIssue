//
//  RegionViewModel.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/08.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation

class RegionViewModel {
    let region: String
    
    init(region: Region) {
        self.region = region.nameKorean
    }
}
