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
    
    func showTextFieldOkCancelAlert(parent: UIViewController,
                                    title: String?,
                                    message: String?,
                                    placeholder: String?,
                                    actionSheetType:ActionSheetType,
                                    completion: @escaping (ActionSheetType, String) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            tf.placeholder = placeholder
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .destructive) { (_) in
            let text = alert.textFields?[0].text

            guard let password = text else {
                return
            }
            completion(actionSheetType, password)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        parent.present(alert, animated: true)
    }
    
    func showOkAlert(parent: UIViewController, title: String?, message: String?) -> () {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .destructive)
        alert.addAction(ok)
        parent.present(alert, animated: true)
    }
    
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
    
//    func showActionSheet(parent: UIViewController, title: String?, message: String?, alertActionList: [UIAlertAction], completion: @escaping (ActionSheetType) -> ()) {
//        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//
//        for alertAction in alertActionList {
//            optionMenu.addAction(alertAction)
//        }
//
//        parent.present(optionMenu, animated: true, completion: nil)
//    }
//
//
//    func setActionSheet(title: String?, message: String?, actions: Dictionary<ActionSheetType, String>, completion: @escaping (ActionSheetType) -> ()) -> UIAlertController {
//        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//        for action in actions {
//            switch action.key {
//            case .DeletePost:
//                let deleteAction = UIAlertAction(title: action.value, style: .default, handler: { (alert: UIAlertAction!) -> Void in
//                    completion(action.key)
//                })
//                optionMenu.addAction(deleteAction)
//
//            case .EditPost:
//                let editAction = UIAlertAction(title: action.value, style: .default, handler: {(alert: UIAlertAction!) -> Void in
//                    completion(action.key)
//                })
//                optionMenu.addAction(editAction)
//            default:
//            print("s")
//            }
//        }
//        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
//        optionMenu.addAction(cancelAction)
//        return optionMenu
//    }
    
}
