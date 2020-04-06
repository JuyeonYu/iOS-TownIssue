//
//  PostEditViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/01.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostEditViewController: UIViewController {
    enum PostEditPurpose {
        case Write
        case Edit
    }
    
    var purpose: PostEditPurpose = .Write

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var post: Post? = nil
//    var writer: String? = nil
//    var password: String? = nil
//    var titles: String? = nil
//    var content: String? = nil
//    var idTextField: UITextField? = nil
//    var passwordTextField: UITextField? = nil
//    var titleTextField: UITextField? = nil
//    var contentTextView: UITextView? = nil
    
    let postEditTitleTableViewCellID = "PostEditTitleTableViewCell"
    let postEditTextContentTableViewCellID = "PostEditTextContentTableViewCell"
    let postEditIDPasswordTableViewCellID = "PostEditIDPasswordTableViewCell"
    
    var responder: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postNibName1 = UINib(nibName: postEditTitleTableViewCellID, bundle: nil)
        tableView.register(postNibName1, forCellReuseIdentifier: postEditTitleTableViewCellID)
        
        let postNibName2 = UINib(nibName: postEditTextContentTableViewCellID, bundle: nil)
        tableView.register(postNibName2, forCellReuseIdentifier: postEditTextContentTableViewCellID)

        let postNibName3 = UINib(nibName: postEditIDPasswordTableViewCellID, bundle: nil)
        tableView.register(postNibName3, forCellReuseIdentifier: postEditIDPasswordTableViewCellID)
        
        //inside viewDidLoad
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let writeNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("done", comment: ""), style: .plain, target: self, action: #selector(didTapWritetNavigationButton))
        self.navigationItem.rightBarButtonItem = writeNavigationButton
        
//        if post != nil {
//            purpose = .Edit
//        }
        
//        idTextField?.text = post?.writer
//        passwordTextField?.text = post?.pw
//        titleTextField?.text = post?.title
//        contentTextView?.text = post?.content
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 80, right: 0)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        let writeNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("write", comment: ""), style: .plain, target: self, action: #selector(didTapWritetNavigationButton))
        self.navigationItem.rightBarButtonItem = writeNavigationButton
    }
    
    @objc func didTapWritetNavigationButton() {
        print("current IP: \(DataUtil.sharedInstance.getWiFiAddress() ?? "f")")
        
        guard let writer = post?.writer else {
            return
        }
        
        guard let password = post?.pw else {
            return
        }
        
        guard let title = post?.title else {
            return
        }
        
        guard let content = post?.content else {
            return
        }
        
        guard let ip = DataUtil.sharedInstance.getWiFiAddress() else {
            return
        }
        
        
        
        switch purpose {
        case .Write:
            let parameter: Dictionary<String, Any> =
            [Network.kAreaIndex:82, Network.kUserIndex:1, Network.kTitle:title, Network.kContent:content, Network.kWriter:writer, Network.kPassword:password, Network.kIP:ip]
            
            NetworkManager.sharedInstance.requestCreatePost(paramters: parameter) { (result) in
                let alert = UIAlertController(title: "", message: NSLocalizedString("The post is created", comment: ""), preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: false)
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        case .Edit:
            let parameter: Dictionary<String, Any> =
                [Network.kBoardIndex:post!.boardIdx, Network.kTitle:title, Network.kContent:content]
            NetworkManager.sharedInstance.requestUpdatePost(paramters: parameter) { (result) in
                let alert = UIAlertController(title: "", message: NSLocalizedString("The post is edited", comment: ""), preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: false)
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    }
}

extension PostEditViewController: UITableViewDelegate {
    
}


extension PostEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: postEditIDPasswordTableViewCellID, for: indexPath) as! PostEditIDPasswordTableViewCell
            
            if self.post != nil {
                cell.model = PostEditViewModel(post: post!)
            }
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: postEditTitleTableViewCellID, for: indexPath) as! PostEditTitleTableViewCell
            cell.delegate = self
            
            if self.post != nil {
                cell.model = PostEditViewModel(post: post!)
            }
            
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: postEditTextContentTableViewCellID, for: indexPath) as! PostEditTextContentTableViewCell
            cell.delegate = self
            
            if self.post != nil {
                cell.model = PostEditViewModel(post: post!)
            }
            
            return cell
        }
    }
}

extension PostEditViewController: PostEditTextContentTableViewCellDelegate {
    func setContent(content: String) {
        self.post?.content = content
    }
    
    func updateHeightOfRow(_ cell: PostEditTextContentTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension PostEditViewController: PostEditTitleTableViewCellDelegate {
    func setTitle(title: String) {
        self.post?.title = title
    }
}

extension PostEditViewController: PostEditIDPasswordTableViewCellDelegate {
    func setWriter(writer: String) {
        self.post?.writer = writer
    }
    
    func setPassword(password: String) {
        self.post?.pw = password
    }
}
