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
    @IBOutlet weak var colletionView: UICollectionView! {
        didSet {
            colletionView.delegate = self
            colletionView.dataSource = self
        }
    }
    var regionList: [Region] = [] {
      didSet {
        colletionView.reloadData()
      }
    }
    
    var currentArea: Region? = nil
    
    let postListTableViewCellID = "PostListTableViewCell"
    let postViewControllerID = "PostViewController"
    let postEditViewControllerID = "PostEditViewController"
    let regionCollectionViewCellID = "RegionCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentArea == nil {
            self.navigationItem.title = "대한민국"
        } else {
            self.navigationItem.title = currentArea?.nameKorean
        }
        
        let regionNibName = UINib(nibName: regionCollectionViewCellID, bundle: nil)
        colletionView.register(regionNibName, forCellWithReuseIdentifier: regionCollectionViewCellID)
                
        let postNibName = UINib(nibName: postListTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postListTableViewCellID)
        
        let menuNavigationButton = UIBarButtonItem.init(title: NSLocalizedString("write", comment: ""), style: .plain, target: self, action: #selector(didTapWritePostNavigationButton))
        self.navigationItem.rightBarButtonItem = menuNavigationButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if currentArea == nil {
            NetworkManager.sharedInstance.requestRegion1Depth { (result) in
                self.regionList = result as! [Region]
            }
            
            NetworkManager.sharedInstance.requestReadAllPostList { (result) in
                self.postList = result as! [Post]
                self.postList.reverse()
            }
        } else {
            NetworkManager.sharedInstance.requestRegionsWithParentIndex(parentIndex: currentArea!.areaIdx) { (result) in
                self.regionList = result as! [Region]
            }
            
            NetworkManager.sharedInstance.requestReadPostWithAreaIndex(areaIndex: currentArea!.areaIdx) { (result) in
                self.postList = result as! [Post]
                self.postList.reverse()
            }
        }
    }
    
    @objc func didTapWritePostNavigationButton() {
        let viewController = self.storyboard?.instantiateViewController(identifier: postEditViewControllerID) as! PostEditViewController
        viewController.purpose = .Write
        viewController.currentArea = currentArea
        viewController.post = Post(status: nil, boardIdx: 0, areaIdx: 0, userIdx: 0, title: "", content: "", writer: "", pw: "", ip: "", view: 0, insDate: "", delDate: nil, delFlag: "", updDate: "")
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


extension PostListViewController: UICollectionViewDelegate {
    
}

extension PostListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.colletionView.dequeueReusableCell(withReuseIdentifier: regionCollectionViewCellID, for: indexPath) as! RegionCollectionViewCell
        cell.model = RegionViewModel(region: self.regionList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension PostListViewController: RegionCollectionViewCellDelegate {
    func didTapRegionButton(cell: RegionCollectionViewCell) {
        guard let indexPath = self.colletionView.indexPath(for: cell) else {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(identifier: "PostListViewController") as! PostListViewController
        vc.currentArea = self.regionList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
