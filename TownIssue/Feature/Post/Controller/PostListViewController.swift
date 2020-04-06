//
//  ViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    var postList: [Post] = [] {
      didSet {
        tableView.reloadData()
      }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let postListTableViewCellID = "PostListTableViewCell"
    let postViewControllerID = "PostViewController"
    let postEditViewControllerID = "PostEditViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postNibName = UINib(nibName: postListTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postListTableViewCellID)
        
        let menuNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("write", comment: ""), style: .plain, target: self, action: #selector(didTapWritePostNavigationButton))
        self.navigationItem.rightBarButtonItem = menuNavigationButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.sharedInstance.requestReadAllPostList { (result) in
            self.postList = result as! [Post]
            self.postList.reverse()
        }
    }
    
    @objc func didTapWritePostNavigationButton() {
        let viewController = self.storyboard?.instantiateViewController(identifier: postEditViewControllerID) as! PostEditViewController
        viewController.purpose = .Write
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(identifier: postViewControllerID) as! PostViewController
        viewController.post = self.postList[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: postListTableViewCellID, for: indexPath) as! PostListTableViewCell
        cell.model = PostListViewModel(post: self.postList[indexPath.row])
        return cell
    }
}
