//
//  PostEditTextContentTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditTextContentTableViewCellDelegate: class {
    func setContent(content: String)
}

class PostEditTextContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    weak var delegate: PostEditTextContentTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: PostEditViewModel! {
        didSet {
            contentTextView.text = model.textContent
        }
    }
    
    
}

extension PostEditTextContentTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.setContent(content: textView.text)
        if contentTextView.text == "" {
            contentTextView.text = "본문을 입력하세요"
        }
    }
}

