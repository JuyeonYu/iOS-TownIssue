//
//  PostEditIDPasswordTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditIDPasswordTableViewCellDelegate: class {
    func saveWriter(writer: String)
    func savePassword(password: String)
}

class PostEditIDPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    weak var delegate: PostEditIDPasswordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        idTextField.placeholder = NSLocalizedString("nickName", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")

//        idTextField.delegate = self
//        passwordTextField.delegate = self
        
        idTextField.addTarget(self, action: #selector(idChanged(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged(textField:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: PostEditViewModel! {
        didSet {
            idTextField.text = model.writer
        }
    }
    
    @objc func idChanged(textField: UITextField) -> Void {
        delegate?.saveWriter(writer: textField.text ?? "")
    }
    
    @objc func passwordChanged(textField: UITextField) -> Void {
        delegate?.savePassword(password: textField.text ?? "")
    }
}

//extension PostEditIDPasswordTableViewCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text,
//           let textRange = Range(range, in: text) {
//           let updatedText = text.replacingCharacters(in: textRange, with: string)
//
//            if textField == self.idTextField {
////                delegate?.saveWriter(writer: updatedText)
//            } else {
//                delegate?.savePassword(password: updatedText)
//            }
//        }
//        return true
//    }
//}
