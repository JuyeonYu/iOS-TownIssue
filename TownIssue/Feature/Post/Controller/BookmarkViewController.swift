//
//  BookmarkViewController.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/05/05.
//  Copyright © 2020 주연  유. All rights reserved.
//

import UIKit
import RealmSwift


class BookmarkViewController: UIViewController {
    lazy var realm: Realm = {
        return try! Realm()
    }()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    let postListTableViewCellID = "PostListTableViewCell"
    
    var sections: [BookmarkSection] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let postNibName = UINib(nibName: postListTableViewCellID, bundle: nil)
        tableView.register(postNibName, forCellReuseIdentifier: postListTableViewCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.sections.append(BookmarkSection(title: NSLocalizedString("region", comment: ""),
                                        regionCells: DataUtil.sharedInstance.realmRegionsToRegions(realmRegions: Array(realm.objects(RealmRegion.self))),
                                        postCells: nil))
//        self.sections.append(BookmarkSection(title: "post",
//                                        regionCells: nil,
//                                        postCells: Array(realm.objects(RealmPost.self))))
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.sections.removeAll()
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let region = sections[indexPath.section].regionCells?[indexPath.row] else {
            return
        }
        let viewController = self.storyboard?.instantiateViewController(identifier: "PostListViewController") as! PostListViewController
        viewController.currentArea = region
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count != 0 else {
            return 0
        }
        if section == 0 {
            return self.sections[section].regionCells?.count ?? 0
        } else {
            return self.sections[section].postCells?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
            cell.textLabel?.text = sections[indexPath.section].regionCells?[indexPath.row].nameKorean
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
