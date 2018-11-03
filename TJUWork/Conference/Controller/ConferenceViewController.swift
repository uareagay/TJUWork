//
//  ConferenceViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/31.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation

class ConferenceViewController: UIViewController {
    fileprivate var tableView: UITableView!
    fileprivate var conferenceList: [ConferenceItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        headerRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "会议记录"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addConference(_:)))
    }
    
    @objc func headerRefresh() {
        ConferenceHelper.getAllConferenceList(success: { model in
            self.conferenceList = model.data
            self.tableView.reloadData()
            
            
        }, failure: {
            
        })
    }
    
    @objc func addConference(_ sender: UIBarButtonItem) {
        let addVC = AddConferenceViewController()
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
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
//        let data = self.conferenceList[indexPath.section]
//        let detailVC = DetailMessageViewController(mid: data.mid, isReply: false, messageType: .inbox, isReaded: true, isDisplayPeople: false, isConference: true)
//        detailVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(detailVC, animated: true)
        
        let mid = self.conferenceList[indexPath.section].mid
        let detailVC = DetailMessageViewController(mid: mid, isReply: false, messageType: .inbox, isReaded: true, isDisplayPeople: false, isConference: true)
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        
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
        cell.selectionStyle = .none
        
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
