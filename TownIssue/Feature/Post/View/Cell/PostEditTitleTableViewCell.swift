//
//  PostEditITitleTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditTitleTableViewCellDelegate: class {
    func setTitle(title: String)
}

class PostEditTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextFiled: UITextField!
    weak var delegate: PostEditTitleTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextFiled.placeholder = "title"
        titleTextFiled.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: PostEditViewModel! {
        didSet {
            titleTextFiled.text = model.title
        }
    }
}

extension PostEditTitleTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.setTitle(title: textField.text ?? "")
    }
}
