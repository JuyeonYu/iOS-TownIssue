//
//  PostEditIDPasswordTableViewCell.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

protocol PostEditIDPasswordTableViewCellDelegate: class {
    func returnWriterTextField(writerTextField: UITextField)
    func returnPasswordTextField(passwordTextField: UITextField)
}

class PostEditIDPasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    weak var delegate: PostEditIDPasswordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        idTextField.placeholder = "ID"
        passwordTextField.placeholder = "Password"
        
        idTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: PostEditViewModel! {
        didSet {
            idTextField.text = model.writer
            passwordTextField.text = model.password
        }
    }
}

extension PostEditIDPasswordTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.placeholder == "ID" {
            delegate?.returnWriterTextField(writerTextField: textField)
        } else if textField.placeholder == "Password" {
            delegate?.returnPasswordTextField(passwordTextField: textField)
        }
    }
}
