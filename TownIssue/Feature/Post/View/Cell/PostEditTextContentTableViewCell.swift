//
//  PostEditTextContentTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditTextContentTableViewCellDelegate: class {
    func updateHeightOfRow(cell: PostEditTextContentTableViewCell, textView: UITextView)
    func saveContent(content: String)
}

class PostEditTextContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    weak var delegate: PostEditTextContentTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.sizeToFit()
        contentTextView.delegate = self
        
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 0.5
        contentTextView.text = NSLocalizedString("please enter content", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: PostEditViewModel! {
        didSet {
            contentTextView.text = model.content
        }
    }
}

extension PostEditTextContentTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "본문을 입력하세요" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == nil {
           textView.text = "본문을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateHeightOfRow(cell: self, textView: textView)
        delegate?.saveContent(content: textView.text)
    }
}

