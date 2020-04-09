//
//  ReplyTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/09.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol ReplyTableViewCellDelegate: class {
    
}

class ReplyTableViewCell: UITableViewCell {
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func didTapLikeButton(_ sender: Any) {
    }
    @IBOutlet weak var replyButton: UIButton!
    @IBAction func didTapReplyButton(_ sender: Any) {
    }
    
    var model: PostViewModel! {
        didSet {
            guard let replys = model.replys else {
                return
            }
            
            for reply in replys {
                writerLabel.text = reply.writer
                ipLabel.text = reply.ip
                timeLabel.text = reply.insDate
                contentLabel.text = reply.content
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
