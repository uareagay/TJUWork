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
    var menuView: DownMenuView!
    
    fileprivate var selectedArrs: [Int] = []
    var isSelecting: Bool = false {
        didSet {
            if isSelecting == true {
                self.tableView.mj_header = nil
                self.tableView.mj_footer = nil
                menuBtn.isEnabled = false
                addBtn.isEnabled = false
                self.navigationItem.rightBarButtonItem = cancelBarButtonItem
                self.selectAllBtn.alpha = 1.0
                self.deleteBtn.alpha = 1.0
                
                self.tableView.reloadData()
                if self.currentMenuType == .inbox {
                    self.navigationController?.setToolbarHidden(false, animated: true)
                }
            } else {
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
                self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
                menuBtn.isEnabled = true
                addBtn.isEnabled = true
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
                self.selectAllBtn.alpha = 0.0
                self.deleteBtn.alpha = 0.0
                
                selectedArrs = []
                self.tableView.reloadData()
                
                if self.currentMenuType == .inbox {
                    self.navigationController?.setToolbarHidden(true, animated: true)
                }
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
    
    var currentMenuType: DownMenuView.MenuType = .inbox {
        didSet {
            switch currentMenuType {
            case .inbox:
                self.menuBtn.setTitle("收件箱", for: .normal)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
            case .outbox:
                self.menuBtn.setTitle("发件箱", for: .normal)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
            case .draft:
                self.menuBtn.setTitle("草稿箱", for: .normal)
                self.navigationItem.rightBarButtonItem = nil
            }
            self.tableView.mj_footer.resetNoMoreData()
        }
    }
    
    fileprivate let downwardBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-40-10-5, y: 0, width: 12, height: 50))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "向下")!, scaledToWidth: 12.0), for: .normal)
        return btn
    }()
    
    fileprivate let deleteBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30-40, y: UIScreen.main.bounds.size.height-130-30, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "删除")!, scaledToWidth: 60.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate let selectAllBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30+40, y: UIScreen.main.bounds.size.height-130-30, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "全选")!, scaledToWidth: 49.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate var draftLists: DraftListModel!
    fileprivate var outboxLists: OutboxListModel!
    fileprivate var inboxLists: InboxListModel!
    
    //MARK: 增加分页功能
    
    fileprivate var inboxCurPage: Int = 1
    fileprivate var outboxCurPage: Int = 1
    fileprivate var draftCurPage: Int = 1
    fileprivate var inboxList: [InboxMessageModel] = []
    fileprivate var outboxList: [OutboxListData] = []
    fileprivate var draftList: [DraftListData] = []
    
    fileprivate var entireUsersModel: EntireUsersModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
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
//        menuView = DownMenuView(frame: CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0))
        menuView = DownMenuView(frame: CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height+5, width: rect.size.width+30, height: 0))
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
        
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
//        self.tableView.mj_header.beginRefreshing()
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        
        headerRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshInboxLists), name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOutboxLists), name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDraftLists), name: NotificationName.NotificationRefreshDraftLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView), name: NotificationName.NotificationLoginFail.name, object: nil)
        
        semGlobal.signal()
        
        let forwardAction = UIBarButtonItem(title: "转发", style:  .plain, target: self, action: #selector(forwardMessage(_:)))
        let readAction = UIBarButtonItem(title: "标记已读", style:  .plain, target: self, action: #selector(markRead(_:)))
        let unReadAction = UIBarButtonItem(title: "标记未读", style:  .plain, target: self, action: #selector(markUnRead(_:)))
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [unReadAction, readAction, flexItem, forwardAction]
        
        EntireUsersHelper.getEntireUsersInLabels(success: { model in
            self.entireUsersModel = model
        }, failure: {
            
        })
        
    }
    
    @objc func presentLoginView() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    @objc func forwardMessage(_ sender: UIBarButtonItem) {
        guard self.entireUsersModel != nil else {
            return
        }
        guard self.selectedArrs.count > 0 else {
            let rvc = UIAlertController(title: nil, message: "请选择信息", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        let mids = self.selectedArrs.map { self.inboxList[$0].mid }

        let searchPeopleVC = DisplayPeopleViewController(self.entireUsersModel, mids: mids)
        searchPeopleVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchPeopleVC, animated: true)
    }
    
    @objc func markRead(_ sender: UIBarButtonItem) {
        let mids: [String] = self.selectedArrs.map { self.inboxList[$0].mid }
        
        PersonalMessageHelper.markRead(mids: mids, success: {
            self.selectedArrs.forEach { self.inboxList[$0].isRead = "1" }
            self.isSelecting = false
        } , failure: {
            self.isSelecting = false
        })
    }
    
    @objc func markUnRead(_ sender: UIBarButtonItem) {
        let mids: [String] = self.selectedArrs.map { self.inboxList[$0].mid }
        
        PersonalMessageHelper.markUnRead(mids: mids, success: {
            self.selectedArrs.forEach { self.inboxList[$0].isRead = "0" }
            self.isSelecting = false
        }, failure: {
            self.isSelecting = false
        })
    }
    
    @objc func longPressEditing(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let pressPoint = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: pressPoint) {
                selectedArrs.append(indexPath.section)
                isSelecting = true
            }
        }
    }
    
    @objc func dismissMenuView(_ gesture: UITapGestureRecognizer) {
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        UIView.animate(withDuration: 0.25, animations: {
            self.menuView.frame = CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height + 5, width: rect.size.width + 30, height: 0)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
        self.isSelecting = false
        self.tableView.mj_header.endRefreshing()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    @objc func clickSearching(_ sender: UIBarButtonItem) {
        switch currentMenuType {
        case .inbox:
            let searchVC = SearchViewController(SearchViewController.SearchType.inbox)
            searchVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(searchVC, animated: true)
        case .outbox:
            let searchVC = SearchViewController(SearchViewController.SearchType.outbox)
            searchVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(searchVC, animated: true)
        default: break
        }
    }
    
   
    @objc func clickMenuBtn(_ sender: UIButton) {
        if menuBtn.isSelected == false {
            tableView.isScrollEnabled = false
           
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
//            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            self.menuView.frame = CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height+5, width: rect.size.width+30, height: 0)
            self.view.bringSubview(toFront: menuView)
            UIView.animate(withDuration: 0.25, animations: {
//                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 32.5*2)
                 self.menuView.frame = CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height+5, width: rect.size.width+30, height: 50*2)
            })
            self.menuView.showMenuView()
            menuBtn.isSelected = true
        } else {
            tableView.isScrollEnabled = true
            
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
            UIView.animate(withDuration: 0.25, animations: {
//                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
                self.menuView.frame = CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height+5, width: rect.size.width+30, height: 0)
            })
            self.menuView.hideMenuView()
            menuBtn.isSelected = false
        }
    }
    
    @objc func addMessage(_ sender: UIButton) {
        let createMessageVC = CreateMessageViewController()
        createMessageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createMessageVC, animated: true)
    }
    
    @objc func cancelEditStatus(_ sender: UIBarButtonItem) {
        self.isSelecting = false
    }
    
    @objc func selectAllMessage(_ sender: UIButton) {
        self.selectedArrs = []
        switch self.currentMenuType {
        case .inbox:
            for index in 0..<self.inboxList.count {
                selectedArrs.append(index)
            }
        case .outbox:
            for index in 0..<self.inboxList.count {
                selectedArrs.append(index)
            }
        case .draft:
            for index in 0..<self.draftList.count {
                selectedArrs.append(index)
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func deleteMessage(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "删除", message: "确定要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不了", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        let outAction = UIAlertAction(title: "删除", style: .default, handler: { _ in
            var arr: [Int] = []
            
            switch self.currentMenuType {
            case .inbox:
                self.selectedArrs.forEach { arr.append(Int(self.inboxList[$0].mid)!) }
                self.inboxList = self.inboxList.filter { !(arr.contains(Int($0.mid)!)) }
                
                self.isSelecting = false
                PersonalMessageHelper.deleteInbox(mid: arr, success: {
                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                    self.headerRefresh()
                }, failure: {
                    
                })
            case .outbox:
                self.selectedArrs.forEach { arr.append(Int(self.outboxList[$0].mid)!) }
                self.outboxList = self.outboxList.filter { !(arr.contains(Int($0.mid)!)) }
                
                self.isSelecting = false
                PersonalMessageHelper.deleteOutbox(mid: arr, success: {
                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                    self.headerRefresh()
                }, failure: {
                    
                })
            case .draft:
                self.selectedArrs.forEach { arr.append(Int(self.draftList[$0].did)!) }
                self.draftList = self.draftList.filter { !(arr.contains(Int($0.did)!)) }
                
                self.isSelecting = false
                PersonalMessageHelper.deleteDraft(did: arr, success: {
                    self.headerRefresh()
                }, failure: {
                    
                })
            }
        })
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(outAction)
        self.present(alertVC, animated: true, completion: nil)
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
            let data = self.inboxList[indexPath.section]
            let isResponse = data.isResponse
            //1为已回复，0为未回复；-1为通知消息，可以回复，但是不必要回复
            let detailVC: DetailMessageViewController
            let isReaded = data.isRead == "0" ? false : true
            if isResponse == 1 {
                //让他可以进行多次回复
//                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .inbox, isReaded: isReaded)
                detailVC = DetailMessageViewController(mid: data.mid, isReply: true, messageType: .inbox, isReaded: isReaded, isDisplayPeople: true)
            } else if isResponse == -1 {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .inbox, isReaded: isReaded)
            } else if isResponse == 0 {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: true, messageType: .inbox, isReaded: isReaded, isDisplayPeople: true)
            } else {
                //不会执行
                detailVC = DetailMessageViewController()
            }
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .outbox:
            let data = self.outboxList[indexPath.section]
            let detailVC: DetailMessageViewController
            if data.type == "工作消息" {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: true)
            } else {
                detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: false)
            }
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .draft:
            let data = self.draftList[indexPath.section]
            let createMessageVC = CreateMessageViewController(title: data.title, text: data.text, type: data.type)
            createMessageVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(createMessageVC, animated: true)
        }
    }
    
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentMenuType {
        case .inbox:
            return self.inboxList.count
        case .outbox:
            return self.outboxList.count
        case .draft:
            return self.draftList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        
        switch self.currentMenuType {
        case .inbox:
            cell.percentBtn.isHidden = true
            let data = self.inboxList[indexPath.section]
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
            let data = self.outboxList[indexPath.section]
            
            if let percent = data.fraction {
                cell.percentBtn.isHidden = false
                cell.percentBtn.setTitle(percent, for: .normal)
            } else {
                cell.percentBtn.isHidden = true
            }
            
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
            cell.percentBtn.isHidden = true
            let data = self.draftList[indexPath.section]
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
            self.menuView.frame = CGRect(x: rect.origin.x-15, y: rect.origin.y+rect.size.height+5, width: rect.size.width+30, height: 0)
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
        
        self.draftCurPage = 1
        self.inboxCurPage = 1
        self.outboxCurPage = 1
        
        group.enter()
        PersonalMessageHelper.getDraftList(success: { model in
            self.draftList = model.data.data
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.enter()
        PersonalMessageHelper.getOutboxList(success: { model in
            self.outboxList = model.data.data
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.enter()
        PersonalMessageHelper.getInboxList(success: { model in
            self.inboxList = model.data.data.filter { return $0.respondedDelete == 0 }
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            self.tableView.reloadData()
            
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
        })
        
        self.tableView.mj_footer.resetNoMoreData()
    }
    
    @objc func refreshDraftLists() {
//        PersonalMessageHelper.getDraftList(success: { model in
//            self.draftList = model.data.data
////            self.headerRefresh()
//            self.tableView.mj_header = nil
//            self.tableView.mj_footer = nil
//            self.tableView.reloadData()
//            self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
//            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoadMore))
//        }, failure: {
//
//        })
        self.headerRefresh()
    }
    
    @objc func refreshOutboxLists() {
//        PersonalMessageHelper.getOutboxList(success: { model in
//            self.outboxList = model.data.data
////            self.headerRefresh()
//            self.tableView.mj_header = nil
//            self.tableView.mj_footer = nil
//            self.tableView.reloadData()
//            self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
//            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoadMore))
//        }, failure: {
//
//        })
        self.headerRefresh()
    }
    
    @objc func refreshInboxLists() {
//        PersonalMessageHelper.getInboxList(success: { model in
//            self.inboxList = model.data.data.filter { return $0.respondedDelete == 0 }
////            self.headerRefresh()
//            self.tableView.mj_header = nil
//            self.tableView.mj_footer = nil
//            self.tableView.reloadData()
//            self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
//            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.footerLoadMore))
//        }, failure: {
//
//        })
        self.headerRefresh()
    
    }
}

// MARK: 上拉加载
extension MessageViewController {
    
    @objc func loadInbox() {
        inboxCurPage += 1
        PersonalMessageHelper.getInboxList(page: inboxCurPage, success: { model in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
            
            if model.data.data.count == 0 {
                self.inboxCurPage -= 1
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            self.inboxList += model.data.data
            self.tableView.reloadData()
        }, failure: {
            self.inboxCurPage -= 1
        })
        
    }

    @objc func loadOutbox() {
        outboxCurPage += 1
        PersonalMessageHelper.getOutboxList(page: outboxCurPage, success: { model in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
            
            if model.data.data.count == 0 {
                self.outboxCurPage -= 1
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            self.outboxList += model.data.data
            self.tableView.reloadData()
        }, failure: {
            self.outboxCurPage -= 1
        })
        
    }
    
    @objc func loadDraft() {
        draftCurPage += 1
        PersonalMessageHelper.getDraftList(page: draftCurPage, success: { model in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
            
            if model.data.data.count == 0 {
                self.draftCurPage -= 1
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            self.draftList += model.data.data
            self.tableView.reloadData()
        }, failure: {
            self.draftCurPage -= 1
        })
        
    }
    
    @objc func footerLoadMore() {
        switch self.currentMenuType {
        case .inbox:
            loadInbox()
        case .outbox:
            loadOutbox()
        case .draft:
            loadDraft()
        }
    }

}
