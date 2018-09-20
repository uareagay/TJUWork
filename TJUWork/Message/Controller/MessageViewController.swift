//
//  MessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/15.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class MessageViewController: UIViewController {
    
    var tableView: UITableView!
    fileprivate var menuView: DownMenuView!
//    var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var selectedArrs: [Int] = []
    fileprivate var isSelecting: Bool = false {
        didSet {
            if isSelecting == true {
                self.tableView.mj_header = nil
                menuBtn.isEnabled = false
                addBtn.isEnabled = false
                self.navigationItem.rightBarButtonItem = cancelBarButtonItem
                
                self.selectAllBtn.alpha = 1.0
                self.deleteBtn.alpha = 1.0
                
            } else {
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
                menuBtn.isEnabled = true
                addBtn.isEnabled = true
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
                
                self.selectAllBtn.alpha = 0.0
                self.deleteBtn.alpha = 0.0
                selectedArrs = []
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let addBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-20-50, y: 0, width: 50.0, height: 50.0))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "新建消息")!, scaledToWidth: 45.0), for: .normal)
        return btn
    }()
    
    fileprivate var cancelBarButtonItem: UIBarButtonItem!
    
    fileprivate let menuBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-40-10, y: 0, width: 80, height: 50))
        btn.setTitle("收件箱", for: .normal)
        btn.setTitleColor(UIColor(hex6: 0x00518e), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return btn
    }()
    
    fileprivate var currentMenuType: DownMenuView.MenuType = .inbox {
        didSet {
            switch currentMenuType {
            case .inbox:
                self.menuBtn.setTitle("收件箱", for: .normal)
            case .outbox:
                self.menuBtn.setTitle("发件箱", for: .normal)
            case .draft:
                self.menuBtn.setTitle("草稿箱", for: .normal)
            }
        }
    }
    
    fileprivate let downwardBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-40-10-5, y: 0, width: 12, height: 50))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "向下")!, scaledToWidth: 12.0), for: .normal)
        return btn
    }()
    
    fileprivate let deleteBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30-40, y: UIScreen.main.bounds.size.height-130, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "删除")!, scaledToWidth: 60.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate let selectAllBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30+40, y: UIScreen.main.bounds.size.height-130, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "全选")!, scaledToWidth: 49.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate var draftLists: DraftListModel!
    fileprivate var outboxLists: OutboxListModel!
    fileprivate var inboxLists: InboxListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 65
        tableView.separatorStyle = .none
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenuView(_:)))
        hideGesture.delegate = self
        hideGesture.delaysTouchesBegan = true
        tableView.addGestureRecognizer(hideGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEditing(_:)))
        longPress.minimumPressDuration = 0.7
        longPress.name = "LongPress"
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPress)
        
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(deleteBtn)
        self.view.addSubview(selectAllBtn)
       
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        menuView = DownMenuView(frame: CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0))
        menuView.layer.borderColor = UIColor.gray.cgColor
        menuView.layer.borderWidth = 0.2
        menuView.layer.shadowColor = UIColor.gray.cgColor
        menuView.layer.shadowOpacity = 0.8
        menuView.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuView.delegate = self
        self.view.addSubview(menuView)
        
        cancelBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(cancelEditStatus(_:)))
        
        addBtn.addTarget(self, action: #selector(addMessage(_:)), for: .touchUpInside)
        menuBtn.addTarget(self, action: #selector(clickMenuBtn(_:)), for: .touchUpInside)
        downwardBtn.addTarget(self, action: #selector(clickMenuBtn(_:)), for: .touchUpInside)
        selectAllBtn.addTarget(self, action: #selector(selectAllMessage(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteMessage(_:)), for: .touchUpInside)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 65))
        view.backgroundColor = .clear
        let contenView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        contenView.backgroundColor = .white
        contenView.layer.masksToBounds = true
        contenView.layer.cornerRadius = 10
        
        view.addSubview(contenView)
        contenView.addSubview(menuBtn)
        contenView.addSubview(addBtn)
        contenView.addSubview(downwardBtn)
        
        contenView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }
        self.tableView.tableHeaderView = view
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    @objc func longPressEditing(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let pressPoint = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: pressPoint) {
                isSelecting = true
                selectedArrs.append(indexPath.section)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func dismissMenuView(_ gesture: UITapGestureRecognizer) {
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        UIView.animate(withDuration: 0.25, animations: {
            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            self.menuView.hideMenuView()
        })
        menuBtn.isSelected = false
        tableView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "消息"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
        self.navigationController?.navigationBar.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshInboxLists), name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOutboxLists), name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDraftLists), name: NotificationName.NotificationRefreshDraftLists.name, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
        self.isSelecting = false
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func clickSearching(_ sender: UIBarButtonItem) {
        switch currentMenuType {
        case .inbox:
            let searchVC = SearchViewController(SearchViewController.SearchType.inbox)
            self.navigationController?.pushViewController(searchVC, animated: true)
        case .outbox:
            let searchVC = SearchViewController(SearchViewController.SearchType.outbox)
            self.navigationController?.pushViewController(searchVC, animated: true)
        default: break
        }
    }
    
   
    @objc func clickMenuBtn(_ sender: UIButton) {
        if menuBtn.isSelected == false {
            tableView.isScrollEnabled = false
           
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            self.view.bringSubview(toFront: menuView)
            UIView.animate(withDuration: 0.25, animations: {
                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 32.5*2)
            })
            self.menuView.showMenuView()
            menuBtn.isSelected = true
        } else {
            tableView.isScrollEnabled = true
            
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
            UIView.animate(withDuration: 0.25, animations: {
                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            })
            self.menuView.hideMenuView()
            menuBtn.isSelected = false
        }
    }
    
    @objc func addMessage(_ sender: UIButton) {
        let createMessageVC = CreateMessageViewController()
        self.navigationController?.pushViewController(createMessageVC, animated: true)
    }
    
    @objc func cancelEditStatus(_ sender: UIBarButtonItem) {
        self.isSelecting = false
    }
    
    @objc func selectAllMessage(_ sender: UIButton) {
        self.selectedArrs = []
        
        switch self.currentMenuType {
        case .inbox:
            for index in 0..<self.inboxLists.data.count {
                selectedArrs.append(index)
            }
        case .outbox:
            for index in 0..<self.outboxLists.data.count {
                selectedArrs.append(index)
            }
        case .draft:
            for index in 0..<self.draftLists.data.count {
                selectedArrs.append(index)
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func deleteMessage(_ sender: UIButton) {
        var dic: [Int] = []
        
        switch self.currentMenuType {
        case .inbox:
            for i in 0..<self.selectedArrs.count {
                dic.append(Int(self.inboxLists.data[self.selectedArrs[i]].mid)!)
            }
            self.inboxLists.data = self.inboxLists.data.filter({ data in
                if dic.contains(Int(data.mid)!) {
                    return false
                } else {
                    return true
                }
                
            })
            self.isSelecting = false
            PersonalMessageHelper.deleteInbox(mid: dic, success: {
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            }, failure: {
                
            })
            
        case .outbox:
            for i in 0..<self.selectedArrs.count {
                dic.append(Int(self.outboxLists.data[self.selectedArrs[i]].mid)!)
            }
            self.outboxLists.data = self.outboxLists.data.filter({ data in
                if dic.contains(Int(data.mid)!) {
                    return false
                } else {
                    return true
                }
                
            })
            self.isSelecting = false
            PersonalMessageHelper.deleteOutbox(mid: dic, success: {
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            }, failure: {
                
            })
            
        case .draft:
            for i in 0..<self.selectedArrs.count {
                dic.append(Int(self.draftLists.data[self.selectedArrs[i]].did)!)
            }
            self.draftLists.data = self.draftLists.data.filter({ data in
                if dic.contains(Int(data.did)!) {
                    return false
                } else {
                    return true
                }
                
            })
            self.isSelecting = false
            PersonalMessageHelper.deleteDraft(did: dic, success: {
                
            }, failure: {
                
            })
        }
        
    }
    
}

extension MessageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

//        let touchPoint = touch.location(in: self.view)
//        let btnRect = menuBtn.convert(menuBtn.bounds, to: self.view)
//        let viewRect = menuView.convert(menuView.bounds, to: self.view)
//        if btnRect.contains(touchPoint) || viewRect.contains(touchPoint) {
//            print("qaz")
//            return false
//        }
//        print("vv")
//        return true

        if self.menuBtn.isSelected == true {
            if gestureRecognizer.name == "LongPress" {
                gestureRecognizer.setValue(3, forKey: "state")
                return true
            }
            return true
        } else {
            if gestureRecognizer.name == "LongPress" {
                return true
            }
            return false
        }
        
    }
    
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
//        guard section == 0 else {
//            return nil
//        }
//        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 65))
//        view.backgroundColor = .clear
//        let contenView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
//        contenView.backgroundColor = .white
//        contenView.layer.masksToBounds = true
//        contenView.layer.cornerRadius = 10
//        
//        addBtn.removeFromSuperview()
//        menuBtn.removeFromSuperview()
//        downwardBtn.removeFromSuperview()
//        
//        view.addSubview(contenView)
//        contenView.addSubview(menuBtn)
//        contenView.addSubview(addBtn)
//        contenView.addSubview(downwardBtn)
//        
//        contenView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(10)
//            make.top.equalToSuperview().inset(10)
//            make.bottom.equalToSuperview().inset(5)
//        }
//
//        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard isSelecting == false else {
            let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
            if let index = selectedArrs.index(of: indexPath.section) {
                selectedArrs.remove(at: index)
                cell.imgView.image = cell.unselectedImg
            } else {
                selectedArrs.append(indexPath.section)
                cell.imgView.image = cell.selectedImg
            }
            return
        }
        
        switch self.currentMenuType {
        case .inbox:
            let data = self.inboxLists.data[indexPath.section]
            let isResponse = data.isResponse
            //1为已回复，0为未回复；-1为通知消息，可以回复，但是不必要回复
            let detailVC: DetailMessageViewController
            let isReaded = data.isRead == "0" ? false : true
            if isResponse == 1 {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .inbox, isReaded: isReaded)
            } else if isResponse == -1 {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .inbox, isReaded: isReaded)
            } else if isResponse == 0 {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: true, messageType: .inbox, isReaded: isReaded)
            } else {
                //不会执行
                detailVC = DetailMessageViewController()
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
//            if data.isRead == "0" {
//                self.refreshInboxLists()
//            }
        case .outbox:
            let data = self.outboxLists.data[indexPath.section]
            let detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .outbox, isReaded: true)
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .draft:
            let data = self.draftLists.data[indexPath.section]
            let createMessageVC = CreateMessageViewController(title: data.title, text: data.text, type: data.type)
            self.navigationController?.pushViewController(createMessageVC, animated: true)
        }
        
    }
    
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentMenuType {
        case .inbox:
            return self.inboxLists != nil ? self.inboxLists.data.count : 0
        case .outbox:
            return self.outboxLists != nil ? self.outboxLists.data.count : 0
        case .draft:
            return self.draftLists != nil ? self.draftLists.data.count : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        
//        if self.currentMenuType == .draft {
//            let data = self.draftLists.data[indexPath.section]
//            cell.titleLabel.text = data.title
//            if data.type == "0" {
//                cell.nameLabel.text = "通知信息"
//            } else {
//                cell.nameLabel.text = "工作信息"
//            }
//            cell.dateLabel.text = data.createdAt
//
//            guard self.isSelecting == true else {
//                cell.imgView.alpha  = 0.0
//                return cell
//            }
//            cell.imgView.alpha  = 1.0
//            if selectedArrs.contains(indexPath.section) {
//                cell.imgView.image = cell.selectedImg
//            } else {
//                cell.imgView.image = cell.unselectedImg
//            }
//            return cell
//        }
        
//        if self.currentMenuType == .outbox {
//            let data = self.outboxLists.data[indexPath.section]
//            cell.titleLabel.text = data.title
//            cell.nameLabel.text = data.type
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            cell.dateLabel.text = formatter.string(from: data.from)
//
//            guard self.isSelecting == true else {
//                cell.imgView.alpha  = 0.0
//                return cell
//            }
//            cell.imgView.alpha  = 1.0
//            if selectedArrs.contains(indexPath.section) {
//                cell.imgView.image = cell.selectedImg
//            } else {
//                cell.imgView.image = cell.unselectedImg
//            }
//            return cell
//        }
        
        switch self.currentMenuType {
        case .inbox:
            let data = self.inboxLists.data[indexPath.section]
            cell.titleLabel.text = data.title
            cell.nameLabel.text = data.type
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.dateLabel.text = formatter.string(from: data.from)
            if data.isRead == "0" {
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
            let data = self.outboxLists.data[indexPath.section]
            cell.titleLabel.text = data.title
            cell.nameLabel.text = data.type
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.dateLabel.text = formatter.string(from: data.from)
            cell.titleLabel.textColor = UIColor(hex6: 0x00518e)
            cell.dateLabel.textColor = UIColor(hex6: 0x00518e)
            cell.lineView.backgroundColor = UIColor(hex6: 0x00518e)
            cell.nameLabel.textColor = UIColor(hex6: 0x00518e)
        case .draft:
            let data = self.draftLists.data[indexPath.section]
            cell.titleLabel.text = data.title
            if data.type == "0" {
                cell.nameLabel.text = "通知信息"
            } else {
                cell.nameLabel.text = "工作信息"
            }
            cell.dateLabel.text = data.createdAt
            cell.titleLabel.textColor = UIColor(hex6: 0x00518e)
            cell.dateLabel.textColor = UIColor(hex6: 0x00518e)
            cell.lineView.backgroundColor = UIColor(hex6: 0x00518e)
            cell.nameLabel.textColor = UIColor(hex6: 0x00518e)
        }
        
        guard self.isSelecting == true else {
            cell.imgView.alpha  = 0.0
            return cell
        }
        
        cell.imgView.alpha  = 1.0
        if selectedArrs.contains(indexPath.section) {
            cell.imgView.image = cell.selectedImg
        } else {
            cell.imgView.image = cell.unselectedImg
        }
        return cell
    }
}

extension MessageViewController: DropDownDelegate {
    func didSelectCell(_ type: DownMenuView.MenuType) {
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        UIView.animate(withDuration: 0.25, animations: {
            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
        })
        
        self.menuView.hideMenuView()
        self.menuBtn.isSelected = false
        self.tableView.isScrollEnabled = true
        self.currentMenuType = type
        self.tableView.reloadData()
    }
}

extension MessageViewController {
    
    @objc func headerRefresh() {
        let group = DispatchGroup()
        
        group.enter()
        PersonalMessageHelper.getDraftList(success: { model in
            self.draftLists = model
            self.tableView.reloadData()
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.enter()
        PersonalMessageHelper.getOutboxList(success: { model in
            self.outboxLists = model
            self.tableView.reloadData()
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.enter()
        PersonalMessageHelper.getInboxList(success: { model in
            self.inboxLists = model
            self.inboxLists.data = self.inboxLists.data.filter({ data in
                //0为未被删除，1为被删除了
                if data.respondedDelete == 0 {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadData()
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        })
        
    }
    
    @objc func refreshDraftLists() {
        PersonalMessageHelper.getDraftList(success: { model in
            self.draftLists = model
            self.tableView.reloadData()
        }, failure: {
            
        })
    }
    
    @objc func refreshOutboxLists() {
        PersonalMessageHelper.getOutboxList(success: { model in
            self.outboxLists = model
            self.tableView.reloadData()
        }, failure: {
            
        })
    }
    
   @objc func refreshInboxLists() {
        PersonalMessageHelper.getInboxList(success: { model in
            self.inboxLists = model
            self.inboxLists.data = self.inboxLists.data.filter({ data in
                //0为未被删除，1为被删除了
                if data.respondedDelete == 0 {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadData()
        }, failure: {
            
        })
    }
    
}
