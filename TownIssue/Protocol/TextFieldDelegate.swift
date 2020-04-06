//
//  TextFieldDelegate.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/04.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldDelegate: class {
    func setTextField(textView: UITextView)
    func returnText(text: String)
}

