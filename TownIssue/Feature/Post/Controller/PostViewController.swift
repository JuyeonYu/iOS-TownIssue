//
//  PostViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var replyPurpose: ReplyEditPurpose = .Write
    var replyIndex: Int? = nil
    var replyPassword: String? = nil
    
//    MARK: Set tableview and collection view
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
//    MARK: Set default value
    var post: Post? = nil
    
    let postTableViewCellID = "PostTableViewCell"
    let replyTableViewCellID = "ReplyTableViewCell"
    let postEditViewControllerID = "PostEditViewController"
    let AdvertiseMentTableViewCellID = "AdvertiseMentTableViewCell"
    
    let postCount = 1
    let advertisementCount = 1
    let postRow = 0
    let advertisementRow = 1
        
    @IBOutlet weak var replyWriterTextField: UITextField! {
        didSet {
            replyWriterTextField.placeholder = NSLocalizedString("nickName", comment: "")
        }
    }
    @IBOutlet weak var replyPasswordTextField: UITextField! {
        didSet {
            replyPasswordTextField.placeholder = NSLocalizedString("password", comment: "")
        }
    }
    @IBOutlet weak var replyTextView: UITextView! {
        didSet {
            replyTextView.delegate = self
            replyTextView.text = NSLocalizedString("enter content", comment: "")
        }
    }
    @IBOutlet weak var sendReplyButton: UIButton!
    @IBAction func didTapSendReplyButton(_ sender: Any) {
        
        guard let content = replyTextView.text,
            replyTextView.text != "" else {
            let alert = UIAlertController(title: NSLocalizedString("enter content", comment: ""),
                                          message: nil,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                   style: .default)
            ActionUtil.sharedInstance.showAlert(viewController: self,
                                                alertController: alert,
                                                useTextField: false,
                                                placehoder: nil,
                                                actions: [ok])
            return
        }
        
        NetworkManager.sharedInstance.getPublicIPAddress { (ip) in
            switch self.replyPurpose {
            case .Write:
                guard let boardIndex = self.post?.boardIdx else { return }
                guard let writer = self.replyWriterTextField.text,
                    self.replyWriterTextField.text != "" else {
                    let alert = UIAlertController(title: NSLocalizedString("enter writer", comment: ""),
                                                  message: nil,
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                           style: .default)
                    ActionUtil.sharedInstance.showAlert(viewController: self,
                                                        alertController: alert,
                                                        useTextField: false,
                                                        placehoder: nil,
                                                        actions: [ok])
                    return
                }
                guard let password = self.replyPasswordTextField.text,
                    self.replyPasswordTextField.text != "" else {
                    let alert = UIAlertController(title: NSLocalizedString("enter password", comment: ""),
                                                  message: nil,
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                           style: .default)
                    ActionUtil.sharedInstance.showAlert(viewController: self,
                                                        alertController: alert,
                                                        useTextField: false,
                                                        placehoder: nil,
                                                        actions: [ok])
                    return
                }
                let parameter: Dictionary<String, Any> = [Network.kBoardIndex:boardIndex,
                                                          Network.kParentIndex:0,
                                                          Network.kWriter:writer,
                                                          Network.kContent:content,
                                                          Network.kPassword:password,
                                                          Network.kIP:ip]
                
                NetworkManager.sharedInstance.createReply(paramters: parameter) { (result) in
                    if result.isSucess {
                        self.replyTextView.resignFirstResponder()
                        self.replyWriterTextField.text = nil
                        self.replyPasswordTextField.text = nil
                        self.replyTextView.text = nil
                        self.readReply()
                    }
                }
                break
                
            case .Edit:
                guard let replyIndex = self.replyIndex else {
                    return
                }
                guard let replyPassword = self.replyPassword else {
                    return
                }
                let parameter: Dictionary<String, Any> = [Network.kContent:content,
                                                          Network.kPassword:replyPassword]
                
                NetworkManager.sharedInstance.updateReply(replyIndex: replyIndex, paramters: parameter) { (result) in
                    if result.isSucess {
                        self.replyTextView.resignFirstResponder()
                        self.replyWriterTextField.text = nil
                        self.replyPasswordTextField.text = nil
                        self.replyTextView.text = nil
                        self.readReply()
                    } else {
                        
                    }
                }
                break
            }
        }
    }
    
    var replyList: [Reply] = [] {
      didSet {
        tableView.reloadData()
      }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let postNibName = UINib(nibName: postTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postTableViewCellID)
        
        let replyNibName = UINib(nibName: replyTableViewCellID, bundle: nil)
        tableView.register(replyNibName, forCellReuseIdentifier: replyTableViewCellID)

        let advertisementNibName = UINib(nibName: AdvertiseMentTableViewCellID, bundle: nil)
        tableView.register(advertisementNibName, forCellReuseIdentifier: AdvertiseMentTableViewCellID)
        
        let menuNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("menu", comment: ""), style: .plain, target: self, action: #selector(didTapMenutNavigationButton))
        self.navigationItem.rightBarButtonItem = menuNavigationButton
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.readPost()
        self.readReply()
        
        
    }
    
    func readPost() {
        guard let postIndex = self.post?.boardIdx else {
            return
        }
        NetworkManager.sharedInstance.readPost(postIndex: postIndex) { (result, post) in
            if result.isSucess {
                self.post = post as? Post
                self.tableView .reloadData()
            } else {
                
            }
        }
    }
    
    func readReply(){
        guard let boardIndex = post?.boardIdx else { return }
        NetworkManager.sharedInstance.readReply(boardIndex: boardIndex) { (result, replyList) in
            if result.isSucess {
                self.replyList = replyList as! [Reply]
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -210
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    
    
    @objc func didTapMenutNavigationButton() {
        let askPasswordAlert = UIAlertController(title: NSLocalizedString("enter password", comment: ""),
                                                 message: nil,
                                                 preferredStyle: .alert)
        
        guard let postIndex = self.post?.boardIdx else {
            return
        }
        
        let edit = UIAlertAction(title: NSLocalizedString("edit", comment: ""), style: .default) { (_) in
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                let text = askPasswordAlert.textFields?[0].text
                guard let password = text else {
                    return
                }
                
                let parameter: Dictionary<String, Any> = [Network.kPassword:password]
                
                NetworkManager.sharedInstance.checkPostPassword(postIndex: postIndex, paramters: parameter) { (result) in
                    if result.isSucess {
                        self.post?.pw = password
                        // go to edit page
                        let viewController = self.storyboard?.instantiateViewController(identifier: self.postEditViewControllerID) as! PostEditViewController
                            viewController.post = self.post
                            viewController.purpose = .Edit
                            self.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    }
                }
            }
            
            let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
            ActionUtil.sharedInstance.showAlert(viewController: self,
                                                alertController: askPasswordAlert,
                                                useTextField: true,
                                                placehoder: "password",
                                                actions: [ok, cancel])
        }
        
        let delete = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .default) { (_) in
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                let text = askPasswordAlert.textFields?[0].text
                
                guard let password = text else { return }
                
                guard let post = self.post else { return }
                
                let parameter: Dictionary<String, Any> = [Network.kPassword:password]
                
                NetworkManager.sharedInstance.deletePost(postIndex: post.boardIdx, parameters: parameter) { (apiReponse, result) in
                    if apiReponse.isSucess {
                        let alert = UIAlertController(title: NSLocalizedString("the post is deleted", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                            self.navigationController?.popViewController(animated: false)
                        }
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    }
                }
            }
            let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
            ActionUtil.sharedInstance.showAlert(viewController: self,
                                                alertController: askPasswordAlert,
                                                useTextField: true,
                                                placehoder: NSLocalizedString("password", comment: ""),
                                                actions: [ok, cancel])
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ActionUtil.sharedInstance.showAlert(viewController: self,
                                            alertController: actionSheet,
                                            useTextField: false,
                                            placehoder: nil,
                                            actions: [edit, delete, cancel])
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCount + advertisementCount + replyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == postRow {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: postTableViewCellID, for: indexPath) as! PostTableViewCell
            cell.model = PostViewModel(post: self.post!)
            return cell
        } else if indexPath.row == advertisementRow {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: AdvertiseMentTableViewCellID, for: indexPath) as! AdvertiseMentTableViewCell
            return cell
        } else { // reply
            let cell = self.tableView.dequeueReusableCell(withIdentifier: replyTableViewCellID, for: indexPath) as! ReplyTableViewCell
            cell.model = ReplyViewModel(reply: self.replyList[indexPath.row - 2])
            cell.delegate = self
            return cell
        }
    }
    
    
}

extension PostViewController: UITableViewDelegate {
    
}

extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == NSLocalizedString("enter content", comment: "") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = NSLocalizedString("enter content", comment: "")
            textView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension PostViewController: ReplyTableViewCellDelegate {
    func didTapMenuButton(cell: ReplyTableViewCell) {
        let askPasswordAlert = UIAlertController(title: NSLocalizedString("enter password", comment: ""),
                                                 message: nil,
                                                 preferredStyle: .alert)
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        let replyIndex = self.replyList[indexPath.row - 2].commentIdx
        
        let edit = UIAlertAction(title: NSLocalizedString("edit", comment: ""), style: .default) { (_) in
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                let text = askPasswordAlert.textFields?[0].text
                guard let password = text else {
                    return
                }
                
                let parameter: Dictionary<String, Any> = [Network.kPassword:password]
                
                NetworkManager.sharedInstance.checkReplyPassword(replyIndex: replyIndex, paramters: parameter) { (result) in
                    if result.isSucess {
                        self.replyTextView.becomeFirstResponder()
                        self.replyTextView.text = self.replyList[indexPath.row - 2].content
                        self.replyWriterTextField.isHidden = true
                        self.replyPasswordTextField.isHidden = true
                        self.replyPurpose = .Edit
                        self.replyIndex = replyIndex
                        self.replyPassword = password
                        // go to edit page
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    }
                }
            }
            
            let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
            ActionUtil.sharedInstance.showAlert(viewController: self,
                                                alertController: askPasswordAlert,
                                                useTextField: true,
                                                placehoder: "password",
                                                actions: [ok, cancel])
        }
            

        let delete = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .default) { (_) in
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                let text = askPasswordAlert.textFields?[0].text
                
                guard let password = text else { return }
                
                let parameter: Dictionary<String, Any> = [Network.kPassword:password]
                NetworkManager.sharedInstance.deleteReply(replyIndex: replyIndex, parameters: parameter) { (result) in
                    if result.isSucess {
                        let alert = UIAlertController(title: NSLocalizedString("the reply is deleted", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                            self.navigationController?.popViewController(animated: false)
                        }
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""),
                                                      message: nil,
                                                      preferredStyle: .alert)
                        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                        ActionUtil.sharedInstance.showAlert(viewController: self,
                                                            alertController: alert,
                                                            useTextField: false,
                                                            placehoder: nil,
                                                            actions: [ok])
                    }
                }
            }
            let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
            ActionUtil.sharedInstance.showAlert(viewController: self,
                                                alertController: askPasswordAlert,
                                                useTextField: true,
                                                placehoder: NSLocalizedString("password", comment: ""),
                                                actions: [ok, cancel])
        }
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ActionUtil.sharedInstance.showAlert(viewController: self,
                                            alertController: actionSheet,
                                            useTextField: false,
                                            placehoder: nil,
                                            actions: [edit, delete, cancel])
    }
}
