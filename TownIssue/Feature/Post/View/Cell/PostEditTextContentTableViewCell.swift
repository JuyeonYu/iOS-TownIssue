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
    func returnContentTextView(textView: UITextView)
}

class PostEditTextContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    weak var delegate: PostEditTextContentTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.sizeToFit()
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.returnContentTextView(textView: textView)
        
        if textView.text == "본문을 입력하세요" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
           textView.text = "본문을 입력하세요"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateHeightOfRow(cell: self, textView: textView)
    }
}

