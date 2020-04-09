//
//  PostEditViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/04/01.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostEditViewController: UIViewController {
    var purpose: PostEditPurpose = .Write

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var currentArea: Region? = nil
    var post: Post? = nil
    
    let postEditTitleTableViewCellID = "PostEditTitleTableViewCell"
    let postEditTextContentTableViewCellID = "PostEditTextContentTableViewCell"
    let postEditIDPasswordTableViewCellID = "PostEditIDPasswordTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleCellNib = UINib(nibName: postEditTitleTableViewCellID, bundle: nil)
        tableView.register(titleCellNib, forCellReuseIdentifier: postEditTitleTableViewCellID)
        
        let textContentNib = UINib(nibName: postEditTextContentTableViewCellID, bundle: nil)
        tableView.register(textContentNib, forCellReuseIdentifier: postEditTextContentTableViewCellID)

        let idPasswordNib = UINib(nibName: postEditIDPasswordTableViewCellID, bundle: nil)
        tableView.register(idPasswordNib, forCellReuseIdentifier: postEditIDPasswordTableViewCellID)
        
        //inside viewDidLoad
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let writeNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("done", comment: ""),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(didTapWritetNavigationButton))
        self.navigationItem.rightBarButtonItem = writeNavigationButton
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
        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default)
        let alert = UIAlertController(title: "", message: NSLocalizedString("The post is created", comment: ""), preferredStyle: .alert)
        guard self.post?.title != "" else {
            ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert,
                                                useTextField: false,
                                                placehoder: nil,
                                                actions: [ok])
            return
        }
        guard self.post?.content != "" else {
            ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert,
                                                useTextField: false,
                                                placehoder: nil,
                                                actions: [ok])
            return
        }
        guard self.post?.writer != "" else {
            ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert,
                                                useTextField: false,
                                                placehoder: nil,
                                                actions: [ok])
            return
        }
        guard self.post?.pw != "" else {
            ActionUtil.sharedInstance.showAlert(viewController: self, alertController: alert,
                                                useTextField: false,
                                                placehoder: nil,
                                                actions: [ok])
            return
        }
        
        guard let post = self.post else {
            return
        }

        NetworkManager.sharedInstance.getPublicIPAddress { (ip) in
            switch self.purpose {
            case .Write:
                let parameter: Dictionary<String, Any> = [Network.kAreaIndex:self.currentArea?.areaIdx ?? 82,
                                                          Network.kUserIndex:1,
                                                          Network.kTitle:post.title,
                                                          Network.kContent:post.content,
                                                          Network.kWriter:post.writer,
                                                          Network.kPassword:post.pw,
                                                          Network.kIP:ip]
                
                NetworkManager.sharedInstance.requestCreatePost(paramters: parameter) { (result) in
                    let alert = UIAlertController(title: "", message: NSLocalizedString("The post is created", comment: ""), preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: false)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            case .Edit:
                let parameter: Dictionary<String, Any> = [Network.kBoardIndex:self.post!.boardIdx,
                                                          Network.kTitle:self.post!.title,
                                                          Network.kContent:self.post!.content]
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
    func saveContent(content: String) {
        self.post?.content = content
    }
    
    func setContent(content: String) {
        self.post?.content = content
    }
    
    func updateHeightOfRow(cell: PostEditTextContentTableViewCell, textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
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
    func saveTitle(title: String) {
        self.post?.title = title
    }
}

extension PostEditViewController: PostEditIDPasswordTableViewCellDelegate {
    func saveWriter(writer: String) {
        self.post?.writer = writer
    }
    
    func savePassword(password: String) {
        self.post?.pw = password
    }
}
