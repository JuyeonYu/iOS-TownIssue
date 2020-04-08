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
    let PostTableViewCellID = "PostTableViewCell"
    let postEditViewControllerID = "PostEditViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postNibName = UINib(nibName: PostTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: PostTableViewCellID)
        
        let menuNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("menu", comment: ""), style: .plain, target: self, action: #selector(didTapMenutNavigationButton))
        self.navigationItem.rightBarButtonItem = menuNavigationButton
    }
    
    @objc func didTapMenutNavigationButton() {
        let actionTypeAndTitleDict: Dictionary<ActionSheetType, String> = [.DeletePost:NSLocalizedString("delete", comment: ""),
                                                                           .EditPost:NSLocalizedString("edit", comment: "")]
        let option = ActionUtil.sharedInstance.setActionSheet(title: nil, message: nil, actions: actionTypeAndTitleDict) { (type) in
            switch type {
            case .DeletePost:
                ActionUtil.sharedInstance.showTextFieldOkCancelAlert(parent: self,
                                                                     title: NSLocalizedString("delete", comment: ""),
                                                                     message: NSLocalizedString("endter password", comment: ""),
                                                                     placeholder: NSLocalizedString("password", comment: ""),
                                                                     actionSheetType: type) { (type, userInput) in
                    if self.isCorrectPassword(password: userInput) {
                        NetworkManager.sharedInstance.requestDeletePost(index: self.post!.boardIdx) { (result) in
                            guard let result = result as? Int else {
                                return
                            }

                            if result == Network.kSuccessDeletePost {
                                ActionUtil.sharedInstance.showOkAlert(parent: self, title: NSLocalizedString("the post is deleted", comment: ""), message: nil)
                            } else if result == Network.kFailDeletePost {
//                                fail to delete on server
                            }
                        }
                    } else {
                        ActionUtil.sharedInstance.showOkAlert(parent: self, title: NSLocalizedString("wrong password", comment: ""), message: nil)
                    }
                }
                
            case .EditPost:
                ActionUtil.sharedInstance.showTextFieldOkCancelAlert(parent: self,
                                                                     title: NSLocalizedString("edit", comment: ""),
                                                                     message: NSLocalizedString("enter password", comment: ""),
                                                                     placeholder: NSLocalizedString("password", comment: ""),
                                                                     actionSheetType: type) { (type, userInput) in
                    if self.isCorrectPassword(password: userInput) {
                        let viewController = self.storyboard?.instantiateViewController(identifier: self.postEditViewControllerID) as! PostEditViewController
                        viewController.post = self.post
                        viewController.purpose = .Edit
                        self.navigationController?.pushViewController(viewController, animated: true)

                    } else {
                        // wrong password
                        ActionUtil.sharedInstance.showOkAlert(parent: self, title: NSLocalizedString("wrong password", comment: ""), message: nil)
                    }
                }
            }
        }
        self.present(option, animated: true, completion: nil)
    }
    
    func isCorrectPassword(password: String) -> Bool {
        return password == self.post?.pw ? true : false
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: PostTableViewCellID, for: indexPath) as! PostTableViewCell
        cell.model = PostViewModel(post: self.post!)
        return cell
    }
}

extension PostViewController: UITableViewDelegate {
    
}
