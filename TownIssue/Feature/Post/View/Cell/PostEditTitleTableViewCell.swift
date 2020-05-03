//
//  PostEditITitleTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditTitleTableViewCellDelegate: class {
    func saveTitle(title: String)
}

class PostEditTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextFiled: UITextField!
    weak var delegate: PostEditTitleTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextFiled.placeholder = NSLocalizedString("title", comment: "")
//        titleTextFiled.delegate = self
        
        titleTextFiled.addTarget(self, action: #selector(titleChanged(textField:)), for: .editingChanged)
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
    
    @objc func titleChanged(textField: UITextField) -> Void {
        delegate?.saveTitle(title: textField.text ?? "")
    }
}

//extension PostEditTitleTableViewCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text, let textRange = Range(range, in: text) {
//            let updatedText = text.replacingCharacters(in: textRange, with: string)
//            delegate?.saveTitle(title: updatedText)
//        }
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("text: \(String(describing: textField.text))")
//    }
//}
