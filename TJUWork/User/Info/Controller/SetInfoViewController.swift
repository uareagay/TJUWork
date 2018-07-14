//
//  SetInfoViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class SetInfoViewController: UIViewController {
    
    fileprivate let imgHeight = UIScreen.main.bounds.width*3/10
    fileprivate let tagArrs = ["用户名：","姓名：", "公职号：", "工资号：", "手机：", "微信：", "邮箱"]
    
    var imgView: UIImageView!
    var tableView: UITableView!
    
    fileprivate let uploadImageBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("上传照片", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0xadc5fd)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("保存更改", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("保存更改", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        tableView.register(SetInfoTableViewCell.self, forCellReuseIdentifier: "SetInfoTableViewCell")
        
        self.view.backgroundColor = .gray
        self.view.addSubview(tableView)

        let tableViewGesture = UITapGestureRecognizer(target: self, action: #selector(receiveGesture(_:)))
        tableViewGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tableViewGesture)
        
        uploadImageBtn.addTarget(self, action: #selector(uploadImage(_:)), for: .touchUpInside)
        
        imgView = UIImageView()
        imgView.backgroundColor = .red
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgHeight/2
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "个人资料"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receiveGesture(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func uploadImage(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        self.view.frame.origin.y = -180
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

extension SetInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width-20, height: 180))
        let contentView = UIView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width-20, height: 180))
        view.backgroundColor = .clear
        contentView.backgroundColor = .white
        
        let maskPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        
        view.addSubview(contentView)
        contentView.addSubview(imgView)
        contentView.addSubview(uploadImageBtn)
        contentView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(imgHeight)
            make.top.equalToSuperview().inset(10)
        }
        uploadImageBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(18)
            make.width.equalTo(imgHeight-15)
            make.height.equalTo(30)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: 100))
        let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: 100))
        view.backgroundColor = .clear
        contentView.backgroundColor = .white
        
        let maskPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        
        view.addSubview(contentView)
        contentView.addSubview(saveBtn)
        contentView.addSubview(cancelBtn)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview().inset(10)
        }
        let btnWidth = imgHeight-15
        let btnHeight = 30
        saveBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
            make.top.equalToSuperview().inset(40)
            make.right.equalTo(contentView.snp.centerX).offset(-20)
        }
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
            make.top.equalToSuperview().inset(40)
            make.left.equalTo(contentView.snp.centerX).offset(20)
        }
        
        
        return view
        
    }
    
}

extension SetInfoViewController: UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row > 1 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as! InfoTableViewCell
            cell.nameLabel.text = tagArrs[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetInfoTableViewCell") as! SetInfoTableViewCell
        cell.nameLabel.text = tagArrs[indexPath.row]
        return cell
        
    }
    
}
