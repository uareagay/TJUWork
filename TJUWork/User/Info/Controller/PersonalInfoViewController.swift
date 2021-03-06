//
//  PersonalInfoViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/27.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import SDWebImage
import SwiftMessages

class PersonalInfoViewController: UIViewController {
    fileprivate var offY: CGFloat = 0
    //fileprivate let imgHeight = UIScreen.main.bounds.width*3/10
    fileprivate let imgHeight = 120
    fileprivate let tagArrs = ["用户名：", "工资号：", "姓名：", "微信：", "邮箱：", "手机：", "办公电话："]
    
    var tableView: UITableView!
    var userInfoModel: UserInfoModel!
    
    fileprivate var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.layer.masksToBounds = true
        //imgView.layer.cornerRadius = UIScreen.main.bounds.width*3/10/2
        imgView.layer.cornerRadius = 120/2
        imgView.image = UIImage(named: "头像")
        return imgView
    }()
    
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
    
//    fileprivate let saveBtn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setTitle("保存更改", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        btn.setTitleColor(.white, for: .normal)
//        btn.titleLabel?.textAlignment = .center
//        btn.backgroundColor = UIColor(hex6: 0x00518e)
//        btn.layer.masksToBounds = true
//        btn.layer.cornerRadius = 13
//        btn.isHidden = true
//        return btn
//    }()
//
//    fileprivate let cancelBtn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setTitle("取消更改", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        btn.setTitleColor(.white, for: .normal)
//        btn.titleLabel?.textAlignment = .center
//        btn.backgroundColor = UIColor(hex6: 0x00518e)
//        btn.layer.masksToBounds = true
//        btn.layer.cornerRadius = 13
//        btn.isHidden = true
//        return btn
//    }()
    
    fileprivate let logoutBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.size.width-20, height: 60)
        btn.setTitle("退出登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = .white
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        tableView.register(SetInfoTableViewCell.self, forCellReuseIdentifier: "SetInfoTableViewCell")
        
        self.view.backgroundColor = .gray
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        
//        let tableViewGesture = UITapGestureRecognizer(target: self, action: #selector(receiveGesture(_:)))
//        //tableViewGesture.cancelsTouchesInView = false
//        self.tableView.addGestureRecognizer(tableViewGesture)
        
        uploadImageBtn.addTarget(self, action: #selector(uploadImage(_:)), for: .touchUpInside)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(GetUserInfo), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
//        cancelBtn.addTarget(self, action: #selector(cancelChangement(_:)), for: .touchUpInside)
//        saveBtn.addTarget(self, action: #selector(saveChangement(_:)), for: .touchUpInside)
//
        //self.GetUserInfo()
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(GetUserInfo))
        //        self.tableView.mj_header.beginRefreshing()
        
        self.setupFooterView()
        self.GetUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(GetUserInfo), name: NotificationName.NotificationRefreshPersonalInfo.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView), name: NotificationName.NotificationLoginFail.name, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "个人资料"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editInfo(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.tableView.mj_header.endRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupFooterView() {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 80))
        contentView.backgroundColor = .clear
        contentView.addSubview(logoutBtn)
        tableView.tableFooterView = contentView
        logoutBtn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
    
    @objc func editInfo(_ sender: UIBarButtonItem) {
        guard self.userInfoModel != nil else {
            return
        }
        
        let editVC = SetInfoViewController(self.userInfoModel)
        editVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func presentLoginView() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    @objc func logout(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "退出", message: "确定要退出吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不了", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        let outAction = UIAlertAction(title: "退出", style: .default, handler: { action in
            AccountManager.logout(success: {
                SwiftMessages.showSuccessMessage(title: "退出成功", body: "")
                let loginVC = LoginViewController()
                self.present(loginVC, animated: true, completion: nil)
                WorkUser.shared.delete()
            }, failure: { error in
                
            })
            
        })
        alertVC.addAction(cancelAction)
        alertVC.addAction(outAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
//    @objc func receiveGesture(_ gesture: UITapGestureRecognizer) {
//        self.view.endEditing(true)
//    }
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//        guard self.userInfoModel != nil else {
//            return
//        }
//
//        self.view.frame.origin.y = -80
//
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        guard self.userInfoModel != nil else {
//            return
//        }
//
//        if CheckEditStatus() {
//            saveBtn.isHidden = false
//            cancelBtn.isHidden = false
//        } else {
//            saveBtn.isHidden = true
//            cancelBtn.isHidden = true
//        }
//
//        self.view.frame.origin.y = 0
//        self.view.layoutIfNeeded()
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}

extension PersonalInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging && scrollView.contentOffset.y < offY {
            self.view.endEditing(true)
        }
        offY = scrollView.contentOffset.y
    }
}

extension PersonalInfoViewController: UITableViewDelegate {
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
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-20, height: 50))
        view.backgroundColor = .clear
        contentView.backgroundColor = .white
        
        let maskPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        
        view.addSubview(contentView)
//        contentView.addSubview(saveBtn)
//        contentView.addSubview(cancelBtn)
//        contentView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.right.bottom.equalToSuperview().inset(10)
//        }
//        let btnWidth = imgHeight-15
//        let btnHeight = 30
//        saveBtn.snp.makeConstraints { make in
//            make.height.equalTo(btnHeight)
//            make.width.equalTo(btnWidth)
//            make.top.equalToSuperview().inset(40)
//            make.right.equalTo(contentView.snp.centerX).offset(-20)
//        }
//        cancelBtn.snp.makeConstraints { make in
//            make.height.equalTo(btnHeight)
//            make.width.equalTo(btnWidth)
//            make.top.equalToSuperview().inset(40)
//            make.left.equalTo(contentView.snp.centerX).offset(20)
//        }
        
        return view
    }
    
}

extension PersonalInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as! InfoTableViewCell
        
        guard self.userInfoModel != nil else {
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "用户名："
            cell.infoLabel.text = userInfoModel.data.name
        case 1:
            cell.nameLabel.text = "工资号："
            cell.infoLabel.text = userInfoModel.data.payNumber
        case 2:
            cell.nameLabel.text = "姓名："
            cell.infoLabel.text = WorkUser.shared.username
        case 3:
            cell.nameLabel.text = "微信："
            cell.infoLabel.text = userInfoModel.data.wechat
        case 4:
            cell.nameLabel.text = "邮箱："
            cell.infoLabel.text = userInfoModel.data.email
        case 5:
            cell.nameLabel.text = "手机："
            cell.infoLabel.text = userInfoModel.data.phone
        case 6:
            cell.nameLabel.text = "办公电话："
            cell.infoLabel.text = userInfoModel.data.officePhone
        default:
            return cell
        }
        
        return cell
//
//        guard indexPath.row != 0 && indexPath.row != 2 else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as! InfoTableViewCell
//            cell.nameLabel.text = tagArrs[indexPath.row]
//            cell.selectionStyle = .none
//
//            guard userInfoModel != nil else {
//                return cell
//            }
//
//            switch indexPath.row {
//            case 0:
//                cell.infoLabel.text = userInfoModel.data.name
//            case 2:
//                cell.infoLabel.text = WorkUser.shared.username
//            default:
//                return cell
//            }
//
//            return cell
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SetInfoTableViewCell") as! SetInfoTableViewCell
//        cell.nameLabel.text = tagArrs[indexPath.row]
//        cell.selectionStyle = .none
//
//        guard userInfoModel != nil else {
//            return cell
//        }
//
//        switch indexPath.row {
//        case 1:
//            cell.infoTextField.text = userInfoModel.data.payNumber
//        case 3:
//            cell.infoTextField.text = userInfoModel.data.wechat
//        case 4:
//            cell.infoTextField.text = userInfoModel.data.email
//        case 5:
//            cell.infoTextField.text = userInfoModel.data.phone
//        case 6:
//            cell.infoTextField.text = userInfoModel.data.officePhone
//        default:
//            return cell
//        }
//        return cell
    }
    
}

extension PersonalInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        var uid: Int = 0
        if let model = userInfoModel {
            uid = model.data.id
        }
        
        UserInfoHelper.uploadAvatar(dictionary: ["avatar":image, "uid": uid], success: {
            self.imgView.image = image
        }, failure: {
            
        })
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadImage(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pictureAction = UIAlertAction(title: "从相册中选择照片", style: .default) { _ in
            
            //            let authStatus = PHPhotoLibrary.authorizationStatus()
            //            guard authStatus == . authorized else {
            //                let rvc = UIAlertController(title: nil, message: "相册不可用，请在设置中打开 TJUWork 的相册权限", preferredStyle: .alert)
            //                self.present(rvc, animated: true, completion: nil)
            //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
            //                    self.presentedViewController?.dismiss(animated: true, completion: nil)
            //                })
            //                return
            //            }
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let rvc = UIAlertController(title: nil, message: "相册不可用，请在设置中打开 TJUWork 的相册权限", preferredStyle: .alert)
                self.present(rvc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                })
            }
        }
        
        let photoAction = UIAlertAction(title: "拍照", style: .default) { _ in
            
            //            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            //            guard authStatus == .authorized else {
            //                let rvc = UIAlertController(title: nil, message: "相机不可用，请在设置中打开 TJUWork 的相机权限", preferredStyle: .alert)
            //                self.present(rvc, animated: true, completion: nil)
            //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
            //                    self.presentedViewController?.dismiss(animated: true, completion: nil)
            //                })
            //                return
            //            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let rvc = UIAlertController(title: nil, message: "相机不可用，请在设置中打开 TJUWork 的相机权限", preferredStyle: .alert)
                self.present(rvc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertVC.addAction(pictureAction)
        alertVC.addAction(photoAction)
        alertVC.addAction(cancelAction)
        
        alertVC.popoverPresentationController?.sourceView = self.view
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension PersonalInfoViewController {
    @objc func GetUserInfo() {
        NetworkManager.getInformation(url: "/user/info", token: WorkUser.shared.token, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let userInfo = try? UserInfoModel(data: data) {
                
                self.userInfoModel = userInfo
                self.tableView.reloadData()
                
                if let picurl =  userInfo.data.picture {
                    print("https://work-alpha.twtstudio.com"+picurl)
                    self.imgView.sd_setImage(with: URL(string: "https://work-alpha.twtstudio.com"+picurl), placeholderImage: UIImage(named: "头像"), options: SDWebImageOptions.retryFailed, completed: nil)
                }
            }
//            if self.tableView.mj_header.isRefreshing {
//                self.tableView.mj_header.endRefreshing()
//            }
        }, failure: { error in
//            if self.tableView.mj_header.isRefreshing {
//                self.tableView.mj_header.endRefreshing()
//            }
        })
    }
//
//    func CheckEditStatus() -> Bool {
//        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.payNumber ?? "" {
//                return true
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.wechat  ?? "" {
//                return true
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.email  ?? "" {
//                return true
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.phone  ?? "" {
//                return true
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.officePhone  ?? "" {
//                return true
//            }
//        }
//
//        return false
//    }
    
//    @objc func cancelChangement(_ sender: UIButton) {
//        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SetInfoTableViewCell {
//            cell.infoTextField.text = userInfoModel.data.payNumber
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SetInfoTableViewCell {
//            cell.infoTextField.text = userInfoModel.data.wechat  ?? ""
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SetInfoTableViewCell {
//            cell.infoTextField.text = userInfoModel.data.email  ?? ""
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? SetInfoTableViewCell {
//            cell.infoTextField.text = userInfoModel.data.phone  ?? ""
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? SetInfoTableViewCell {
//            cell.infoTextField.text = userInfoModel.data.officePhone ?? ""
//        }
//
//        self.view.endEditing(true)
//        self.cancelBtn.isHidden = true
//        self.saveBtn.isHidden = true
//    }
    
//    @objc func saveChangement(_ sender: UIButton) {
//        var dic: [String:String] = [:]
//
//        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.payNumber ?? "" {
//                if cell.infoTextField.text?.count != 6 {
//                    let rvc = UIAlertController(title: nil, message: "工资号必须为6位数字", preferredStyle: .alert)
//                    self.present(rvc, animated: true, completion: nil)
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
//                        self.presentedViewController?.dismiss(animated: true, completion: nil)
//                    })
//                    return
//                }
//                dic["pay_number"] = cell.infoTextField.text
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.wechat  ?? "" {
//                dic["wechat"] = cell.infoTextField.text
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.email  ?? "" {
//                dic["email"] = cell.infoTextField.text
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.phone  ?? ""{
//                dic["phone"] = cell.infoTextField.text
//            }
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? SetInfoTableViewCell {
//            if cell.infoTextField.text != userInfoModel.data.officePhone  ?? "" {
//                dic["office_phone"] = cell.infoTextField.text
//            }
//        }
//
//        UserInfoHelper.uploadUserInfo(dictionary: dic, success: {
//            self.userInfoModel.data.payNumber = dic["pay_number"] ?? self.userInfoModel.data.payNumber
//            self.userInfoModel.data.phone = dic["phone"] ?? self.userInfoModel.data.phone
//            self.userInfoModel.data.wechat = dic["wechat"] ?? self.userInfoModel.data.wechat
//            self.userInfoModel.data.email = dic["email"] ?? self.userInfoModel.data.email
//            self.userInfoModel.data.officePhone = dic["office_phone"] ?? self.userInfoModel.data.officePhone
//
//            self.cancelBtn.isHidden = true
//            self.saveBtn.isHidden = true
//        }, failure: {
//            self.cancelBtn.isHidden = true
//            self.saveBtn.isHidden = true
//        })
//    }
}
