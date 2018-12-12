//
//  ConferenceViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/31.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation
import MJRefresh

class ConferenceViewController: UIViewController {
    fileprivate var tableView: UITableView!
    fileprivate var conferenceList: [ConferenceItem] = []
    fileprivate var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        //headerRefresh()
        self.tableView.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(headerRefresh), name: NotificationName.NotificationRefreshConferenceLists.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView), name: NotificationName.NotificationLoginFail.name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "会议记录"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addConference(_:)))
        
        if (self.tableView.mj_header.scrollViewOriginalInset.top > 0 && self.tableView.mj_header.state == MJRefreshState.idle) {
            let oldContentInset = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: oldContentInset.left, bottom: oldContentInset.bottom, right: oldContentInset.right);
        }
    }
}

extension ConferenceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let mid = String(self.conferenceList[indexPath.section].mid)
        let sendUid = String(self.conferenceList[indexPath.section].sendUid)
        
        if self.uid == sendUid {
            let detailVC = DetailMessageViewController(mid: mid, isReply: false, messageType: .outbox, isReaded: true, isDisplayPeople: false, isConference: true)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let detailVC = DetailMessageViewController(mid: mid, isReply: false, messageType: .inbox, isReaded: true, isDisplayPeople: false, isConference: true)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ConferenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.conferenceList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
//        cell.selectionStyle = .none
        
        cell.percentBtn.isHidden = true
        cell.imgView.alpha  = 0.0
        
        let data = self.conferenceList[indexPath.section]
        cell.titleLabel.text = data.title
        cell.nameLabel.text = data.author
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.dateLabel.text = formatter.string(from: data.to)
        
        cell.titleLabel.textColor = UIColor(hex6: 0x00518e)
        cell.dateLabel.textColor = UIColor(hex6: 0x00518e)
        cell.lineView.backgroundColor = UIColor(hex6: 0x00518e)
        cell.nameLabel.textColor = UIColor(hex6: 0x00518e)

        return cell
    }
}

extension ConferenceViewController {
    @objc func presentLoginView() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    @objc func headerRefresh() {
        let group = DispatchGroup()
        
        group.enter()
        ConferenceHelper.getAllConferenceList(success: { model in
            self.conferenceList = model.data
            group.leave()
        }, failure: {
            group.leave()
        })
        
        group.enter()
        NetworkManager.getInformation(url: "/user/info", token: WorkUser.shared.token, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let userInfo = try? UserInfoModel(data: data) {
                self.uid = String(userInfo.data.id)
            }
            group.leave()
        }, failure: { error in
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func addConference(_ sender: UIBarButtonItem) {
        let addVC = AddConferenceViewController()
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}
