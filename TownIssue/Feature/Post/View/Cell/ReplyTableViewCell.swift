//
//  ReplyTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/09.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol ReplyTableViewCellDelegate: class {
    func didTapMenuButton(cell: ReplyTableViewCell)
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
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func didTapMenuButton(_ sender: Any) {
        delegate?.didTapMenuButton(cell: self)
    }
    
    weak var delegate: ReplyTableViewCellDelegate?
    
    var model: ReplyViewModel! {
        didSet {
            writerLabel.text = model.writer
            timeLabel.text = model.insDate
            contentLabel.text = model.content
            ipLabel.text = model.ip
            timeLabel.text = model.timeElapsed
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

extension ReplyTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
           
//            if textField == self.writerLabel {
//                delegate?.saveWriter(writer: updatedText)
//            } else {
//                delegate?.savePassword(password: updatedText)
//            }
        }
        return true
    }
}


