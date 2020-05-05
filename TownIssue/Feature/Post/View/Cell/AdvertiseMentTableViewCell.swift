//
//  AdvertiseMentTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/12.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class AdvertiseMentTableViewCell: UITableViewCell {

    @IBOutlet weak var advertisermentButton: UIButton!
    @IBAction func didTapAdvertisementButton(_ sender: Any) {
        let email = "townissue@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
