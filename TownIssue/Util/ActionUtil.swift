//
//  ActionUtil.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/01.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import UIKit

class ActionUtil {
    static let sharedInstance = ActionUtil()

    init() {}
    
    func showAlert(viewController: UIViewController,
                   alertController: UIAlertController,
                   useTextField:Bool,
                   placehoder: String?,
                   actions: [UIAlertAction]) {
        if useTextField {
            alertController.addTextField { (textField) in
                textField.placeholder = placehoder
            }
        }
        for action in actions {
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true)
    }
}
