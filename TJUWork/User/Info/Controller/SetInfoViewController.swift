//
//  SetInfoViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class SetInfoViewController: UIViewController {
    fileprivate var tableView: UITableView!
    fileprivate var userInfoModel: UserInfoModel!
    
    convenience init(_ model: UserInfoModel) {
        self.init()
        self.userInfoModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.allowsSelection = false
        tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.register(SetInfoTableViewCell.self, forCellReuseIdentifier: "SetInfoTableViewCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "编辑信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(editMessage(_:)))
    }
}

extension SetInfoViewController {
    @objc func editMessage(_ sender: UIBarButtonItem) {
        var dic: [String:String] = [:]
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SetInfoTableViewCell {
            if cell.infoTextField.text?.count != 6 {
                let rvc = UIAlertController(title: nil, message: "工资号必须为6位数字", preferredStyle: .alert)
                self.present(rvc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            dic["pay_number"] = cell.infoTextField.text
        }
        
        let alertVC = UIAlertController(title: "确认修改信息吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default)
        let saveChangeAction = UIAlertAction(title: "修改", style: .default) { _ in
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetInfoTableViewCell {
                dic["wechat"] = cell.infoTextField.text
            }
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SetInfoTableViewCell {
                if cell.infoTextField.text != self.userInfoModel.data.email {
                    dic["email"] = cell.infoTextField.text
                }
            }
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SetInfoTableViewCell {
                dic["phone"] = cell.infoTextField.text
            }
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SetInfoTableViewCell {
                dic["office_phone"] = cell.infoTextField.text
            }
            
            self.tableView.isUserInteractionEnabled = false
            UserInfoHelper.uploadUserInfo(dictionary: dic, success: {
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshPersonalInfo.name, object: nil)
                self.navigationController?.popViewController(animated: true)
            }, failure: {
                self.tableView.isUserInteractionEnabled = true
            })
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveChangeAction)
        self.present(alertVC, animated: true)
    }
}

extension SetInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetInfoTableViewCell") as! SetInfoTableViewCell
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "微信："
            cell.infoTextField.text = self.userInfoModel.data.wechat
        case 1:
            cell.nameLabel.text = "邮箱："
            cell.infoTextField.text = self.userInfoModel.data.email
        case 2:
            cell.nameLabel.text = "手机："
            cell.infoTextField.text = self.userInfoModel.data.phone
        case 3:
            cell.nameLabel.text = "工资号："
            cell.infoTextField.text = self.userInfoModel.data.payNumber
        case 4:
            cell.nameLabel.text = "办公电话："
            cell.infoTextField.text = self.userInfoModel.data.officePhone
        default:
            break
        }
        return cell
    }
}
