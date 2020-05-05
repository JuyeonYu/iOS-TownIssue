//
//  PostListTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostListTableViewCell: UITableViewCell {

    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var readImage: UIImageView!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func didTapLikeButton(_ sender: Any) {
    }
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBAction func didTapReplyButton(_ sender: Any) {
    }
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func didTapMenuButton(_ sender: Any) {
    }
    
    var model: PostListViewModel! {
        didSet {
            writerLabel.text = model.writer
            titleLabel.text = model.title
            contentLabel.text = model.content
            readCountLabel.text = String(model.view)
            timeLabel.text = model.timeElapsed
            ipLabel.text = model.ip
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
