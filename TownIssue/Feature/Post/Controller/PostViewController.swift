//
//  PostViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var post: Post? = nil
    let postTableViewCellID = "PostTableViewCell"
    let replyTableViewCellID = "ReplyTableViewCell"
    let postEditViewControllerID = "PostEditViewController"
    
    var actionPurpose: ActionSheetType = .DeletePost
    
    @IBOutlet weak var replyTextView: UITextView! {
        didSet {
            replyTextView.delegate = self
        }
    }
    @IBOutlet weak var sendReplyButton: UIButton!
    @IBAction func didTapSendReplyButton(_ sender: Any) {
        if post?.replys == nil {
            post?.replys = []
        }
        let boardIndex = post!.boardIdx
        post?.replys?.append(ReplyTest(boardIdx: boardIndex, userIdx: 1, content: replyTextView.text, writer: "anim", pw: "q", ip: "123", view: 1, insDate: "", delDate: nil, delFlag: "", updDate: nil))

        replyTextView.resignFirstResponder()
        tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postNibName = UINib(nibName: postTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postTableViewCellID)
        
        let replyNibName = UINib(nibName: replyTableViewCellID, bundle: nil)
        tableView.register(replyNibName, forCellReuseIdentifier: replyTableViewCellID)

        
        let menuNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("menu", comment: ""), style: .plain, target: self, action: #selector(didTapMenutNavigationButton))
        self.navigationItem.rightBarButtonItem = menuNavigationButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -210
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @objc func didTapMenutNavigationButton() {
        let askPasswordAlert = UIAlertController(title: NSLocalizedString("enter password", comment: ""), message: nil, preferredStyle: .alert)
        
        let edit = UIAlertAction(title: NSLocalizedString("edit", comment: ""), style: .default) { (_) in
            let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                let text = askPasswordAlert.textFields?[0].text
                guard let password = text else {
                    return
                }
                                
                if password == self.post?.pw {
                    let viewController = self.storyboard?.instantiateViewController(identifier: self.postEditViewControllerID) as! PostEditViewController
                    viewController.post = self.post
                    viewController.purpose = .Edit
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let wrongPasswordAlert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""), message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                    ActionUtil.sharedInstance.showAlert(viewController: self, alertController: wrongPasswordAlert, useTextField: false, placehoder: nil, actions: [ok])
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
                
                guard let password = text else {
                    return
                }
                
                var ok = UIAlertAction()
                if password == self.post?.pw {
                    let alert = UIAlertController(title: NSLocalizedString("the post is deleted", comment: ""), message: nil, preferredStyle: .alert)
                    ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                        guard let post = self.post else { return }
                        NetworkManager.sharedInstance.requestDeletePost(index: post.boardIdx) { (result) in
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                    ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert, useTextField: false, placehoder: nil, actions: [ok])
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("wrong password", comment: ""), message: nil, preferredStyle: .alert)
                    ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
                    ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert, useTextField: false, placehoder: nil, actions: [ok])
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
    
    func isCorrectPassword(password: String) -> Bool {
        return password == self.post?.pw ? true : false
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (self.post?.replys?.count ?? 0) // make 1 constant
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // make 0 constant
            let cell = self.tableView.dequeueReusableCell(withIdentifier: postTableViewCellID, for: indexPath) as! PostTableViewCell
            cell.model = PostViewModel(post: self.post!)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: replyTableViewCellID, for: indexPath) as! ReplyTableViewCell
            cell.model = PostViewModel(post: self.post!)
            return cell
        }
    }
}

extension PostViewController: UITableViewDelegate {
    
}

extension PostViewController: UITextViewDelegate {
}
