//
//  SearchViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/20.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation
//import MJRefresh


class SearchViewController: UIViewController {
    
    enum SearchType {
        case inbox  //收件箱
        case outbox //发件箱
    }
    
    fileprivate var inboxLists: [InboxSearchData] = []
    fileprivate var outboxLists: [OutboxSearchData] = []
    
    fileprivate let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        //searchBar.showsScopeBar = false
        searchBar.tintColor = UIColor(hex6: 0x00518e)
        searchBar.placeholder = "搜索"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.init(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        }
        return searchBar
    }()
    
    fileprivate var tableView: UITableView!
    //fileprivate var currentPage: Int = 0
    fileprivate var currentType: SearchType = .inbox
    
    
    convenience init(_ type: SearchType) {
        self.init(nibName: nil, bundle: nil)
        
        self.currentType = type
        switch type {
        case .inbox:
            self.searchBar.placeholder = "收件箱搜索"
        case .outbox:
            self.searchBar.placeholder = "发件箱搜索"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 20))
        
        
        //let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector())
        
        self.view.addSubview(tableView)
        
        self.searchBar.delegate = self
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = "消息"
        
        //取消返回按钮
        //self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSearch(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
}

extension SearchViewController {
    
    @objc func cancelSearch(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if let searchText = self.searchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
//            searchMessage(with: searchBar.text!)
//        }
        guard let text = searchBar.text else {
            return
        }
        searchMessage(with: text)
    }
    
}

extension SearchViewController {
    
    @objc func loadMore() {
        
    }
    
    func searchMessage(with keyword: String) {
        guard keyword.count > 0 else {
            return
        }
        
        switch currentType {
        case .inbox:
            PersonalMessageHelper.searchInbox(content: keyword, success: { model in
                self.inboxLists = model.data
                self.tableView.reloadData()
            }, failure: {
                
            })
        case .outbox:
            PersonalMessageHelper.searchOutbox(content: keyword, success: { model in
                self.outboxLists = model.data
                self.tableView.reloadData()
            }, failure: {
                
            })
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch self.currentType {
        case .inbox:
            let data = self.inboxLists[indexPath.section]
            let isResponse = data.isResponse
            //1为已回复，0为未回复；-1为通知消息，可以回复，但是不必要回复
            let detailVC: DetailMessageViewController
            let isReaded = data.isRead == 0 ? false : true
            
            if data.type == "会议消息" {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .inbox, isReaded: isReaded, isDisplayPeople: false, isConference: true)
                detailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailVC, animated: true)
                return
            }
            
            if isResponse == 1 {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: true, messageType: .inbox, isReaded: isReaded, isDisplayPeople: true)
            } else if isResponse == -1 {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .inbox, isReaded: isReaded)
            } else if isResponse == 0 {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: true, messageType: .inbox, isReaded: isReaded, isDisplayPeople: true)
            } else {
                //不会执行
                detailVC = DetailMessageViewController()
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .outbox:
            let data = self.outboxLists[indexPath.section]
            let detailVC: DetailMessageViewController

//            if data.type == 0 {
//                cell.nameLabel.text = "通知消息"
//            } else if data.type == 1 {
//                cell.nameLabel.text = "工作消息"
//            } else {
//                cell.nameLabel.text = "会议消息"
//            }

            if data.type == 0 {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: false)
            } else if data.type == 1 {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: true)
            } else {
                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: false, isConference: true)
            }
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)

//            if data.type == 2 {
//                detailVC = DetailMessageViewController(mid: String(data.mid), isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: false, isConference: true)
//                detailVC.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(detailVC, animated: true)
//                return
//            }
//
//            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentType == .inbox ? self.inboxLists.count : self.outboxLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        
        switch self.currentType {
        case .inbox:
            cell.percentBtn.isHidden = true
            let data = self.inboxLists[indexPath.section]
            cell.titleLabel.text = data.title
            cell.nameLabel.text = data.author
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.dateLabel.text = formatter.string(from: data.from)
            if data.isRead == 0 {
                cell.titleLabel.textColor = UIColor(hex6: 0x00518e)
                cell.dateLabel.textColor = UIColor(hex6: 0x00518e)
                cell.lineView.backgroundColor = UIColor(hex6: 0x00518e)
                cell.nameLabel.textColor = UIColor(hex6: 0x00518e)
            } else {
                cell.titleLabel.textColor = UIColor(hex6: 0x16982B)
                cell.dateLabel.textColor = UIColor(hex6: 0x16982B)
                cell.lineView.backgroundColor = UIColor(hex6: 0x16982B)
                cell.nameLabel.textColor = UIColor(hex6: 0x16982B)
            }
        case .outbox:
            let data = self.outboxLists[indexPath.section]
            cell.titleLabel.text = data.title
            
            if data.type == 0 {
                cell.nameLabel.text = "通知消息"
            } else if data.type == 1 {
                cell.nameLabel.text = "工作消息"
            } else {
                cell.nameLabel.text = "会议消息"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.dateLabel.text = formatter.string(from: data.from)
            cell.titleLabel.textColor = UIColor(hex6: 0x00518e)
            cell.dateLabel.textColor = UIColor(hex6: 0x00518e)
            cell.lineView.backgroundColor = UIColor(hex6: 0x00518e)
            cell.nameLabel.textColor = UIColor(hex6: 0x00518e)
        }
        
        return cell
    }
    
    
}
