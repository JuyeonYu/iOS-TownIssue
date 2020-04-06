//
//  PostTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func didTapLikeButton(_ sender: Any) {
    }
    @IBAction func replyButton(_ sender: Any) {
    }
    @IBAction func didTapReplyButton(_ sender: Any) {
    }
    @IBOutlet weak var secondStackView: UIStackView!
    
    var model: PostViewModel! {
        didSet {
            writerLabel.text = model.writer
            ipLabel.text = model.ip
            titleLabel.text = model.title
            contentLabel.text = model.content
            timeLabel.text = model.insDate
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
