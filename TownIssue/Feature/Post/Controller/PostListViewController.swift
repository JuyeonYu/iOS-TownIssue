//
//  ViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import RealmSwift


class PostListViewController: UIViewController {
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    //    MARK: Set tableview and collection view
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var postList: [Post] = [] {
      didSet {
        tableView.reloadData()
      }
    }
    
    var regionList: [Region] = [] {
      didSet {
        collectionView.reloadData()
      }
    }
    
//    MARK: Set default value
    let KoreaIndex = 82
    var currentArea: Region = Region(status: nil,
                                     areaIdx: 82,
                                     cityIdx: 0,
                                     cityName: "대한민국",
                                     districtIdx: 0,
                                     districtName: "",
                                     townIdx: 0,
                                     townName: "",
                                     parentIdx: 0,
                                     depth: 0,
                                     nameKorean: "대한민국",
                                     nameEnglish: "",
                                     nameChinese: "")
    
    let postListTableViewCellID = "PostListTableViewCell"
    let postViewControllerID = "PostViewController"
    let postEditViewControllerID = "PostEditViewController"
    let regionCollectionViewCellID = "RegionCollectionViewCell"

    @IBOutlet weak var bookMarkButton: UIBarButtonItem!
    @IBAction func didTapBookMarkButton(_ sender: Any) {
        let realmRegion = RealmRegion()
        realmRegion.areaIdx = currentArea.areaIdx
        realmRegion.nameKorean = currentArea.nameKorean
        
        if bookMarkButton.image == UIImage(systemName: "bookmark.fill") {
            bookMarkButton.image = UIImage(systemName: "bookmark")
            try! self.realm.write {
                self.realm.delete(realm.objects(RealmRegion.self).filter("areaIdx = \(self.currentArea.areaIdx)"))
            }
        } else {
            bookMarkButton.image = UIImage(systemName: "bookmark.fill")
            
            try! self.realm.write {
                self.realm.add(realmRegion)
            }
        }
        
    }
    @IBOutlet weak var writeButton: UIBarButtonItem!
    @IBAction func didTapWriteButton(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: postEditViewControllerID) as! PostEditViewController
        viewController.purpose = .Write
        viewController.currentArea = currentArea
        viewController.post = Post(areaIdx: currentArea.areaIdx,
                                   view: 0,
                                   insDate: "",
                                   boardIdx: 0,
                                   writer: "",
                                   title: "",
                                   content: NSLocalizedString("please enter content", comment: ""),
                                   ip: "",
                                   pw: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    //    MARK: Viewcontroller life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = currentArea.nameKorean

        let regionNibName = UINib(nibName: regionCollectionViewCellID, bundle: nil)
        collectionView.register(regionNibName, forCellWithReuseIdentifier: regionCollectionViewCellID)
                
        let postNibName = UINib(nibName: postListTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postListTableViewCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if currentArea.areaIdx == KoreaIndex {
            NetworkManager.sharedInstance.readDepth1Regions { (apiReponse, result) in
                self.regionList = result as! [Region]
            }
        } else {
            NetworkManager.sharedInstance.readSonRegions(parentIndex: currentArea.areaIdx) { (apiReponse, result) in
                self.regionList = result as! [Region]
            }
        }

        NetworkManager.sharedInstance.readAreaPost(areaIndex: currentArea.areaIdx) { (apiReponse, result) in
            self.postList = result as! [Post]
        }
        
        if regionList.count == 0 {
            
        }
//        let result = realm.objects(RealmRegion.self).filter("regionIndex = \(self.currentArea.areaIdx)").isEmpty
        if realm.objects(RealmRegion.self).filter("areaIdx = \(self.currentArea.areaIdx)").isEmpty {
            bookMarkButton.image = UIImage(systemName: "bookmark")
        } else {
            bookMarkButton.image = UIImage(systemName: "bookmark.fill")
        }
        
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath.row: \(indexPath.row)")
        if indexPath.row == self.postList.count - 1 {
            print("request more")
        }
    }
}

extension PostListViewController: UICollectionViewDelegate {
    
}

extension PostListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: regionCollectionViewCellID, for: indexPath) as! RegionCollectionViewCell
        cell.model = RegionViewModel(region: self.regionList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension PostListViewController: RegionCollectionViewCellDelegate {
    func didTapRegionButton(cell: RegionCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(identifier: "PostListViewController") as! PostListViewController
        vc.currentArea = self.regionList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
