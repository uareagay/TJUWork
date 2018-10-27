//
//  LoginViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/13.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages


class LoginViewController: UIViewController {
    fileprivate let tjuImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.resizedImage(image: UIImage(named: "TJULogo")!, scaledToWidth: UIScreen.main.bounds.width/3)
        return imgView
    }()
    
    fileprivate let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.resizedImage(image: UIImage(named: "logo")!, scaledToWidth: UIScreen.main.bounds.width/2+50)
        return imgView
    }()
    
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "用户名："
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        return label
    }()
    
    fileprivate let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "密码 ："
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        return label
    }()

    fileprivate let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .next
        //textField.placeholder = "用户"
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        return textField
    }()
    
    fileprivate let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        //textField.placeholder = "密码"
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        return textField
    }()

    fileprivate let loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textColor = .black
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(tjuImageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginBtn)
        self.view.addSubview(logoImageView)
        
        loginBtn.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    
        tjuImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.width/3-50)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            //make.top.equalTo(tjuImageView.snp.bottom).offset(UIScreen.main.bounds.width/6-10)
            make.top.equalTo(tjuImageView.snp.bottom).offset(40)
            make.width.equalTo(280)
            make.height.equalTo(100)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width/8)
            make.top.equalTo(UIScreen.main.bounds.height/2)
            make.height.equalTo(40);
            make.width.equalTo(70)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width/8)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(40);
            make.width.equalTo(70)
        }
        
        
        
        usernameTextField.snp.makeConstraints { make in
            make.left.equalTo(usernameLabel.snp.right)
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width/8)
            make.height.equalTo(35)
            make.centerY.equalTo(usernameLabel.snp.centerY)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(passwordLabel.snp.right)
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width/8)
            make.height.equalTo(35)
            make.centerY.equalTo(passwordLabel.snp.centerY)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            //make.width.equalTo(UIScreen.main.bounds.width*2.2/5)
            //make.height.equalTo(UIScreen.main.bounds.width*2/15)
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(100)
            //make.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/5)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    

    @objc func login(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let username = usernameTextField.text, !username.isEmpty else {
            SwiftMessages.showErrorMessage(title: "", body: "请填写用户名")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            SwiftMessages.showErrorMessage(title: "", body: "请填写密码")
            return
        }
        
        loginBtn.isEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        
        AccountManager.getToken(username: username, password: password, success: { token in
            WorkUser.shared.token = token
            WorkUser.shared.username = username
            WorkUser.shared.password = password
            WorkUser.shared.save()
            
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshPersonalInfo.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//            NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
//            NotificationCenter.default.post(name: NotificationName.NotificationRefreshDraftLists.name, object: nil)
            if let clientID = WorkUser.shared.clientID {
                NetworkManager.postInformation(url: "/user/device", token: WorkUser.shared.token, parameters: ["cid": clientID], success:{ dic in
                    print(dic)
                }, failure:{ error in
                    
                })
            }
            
            self.dismiss(animated: true, completion: {
                SwiftMessages.showSuccessMessage(title: "登录成功", body: "")
            })
        }, failure: { errorMeg in
            SwiftMessages.showErrorMessage(title: "登录失败", body: "")
            self.loginBtn.isEnabled = true
            self.usernameTextField.isUserInteractionEnabled = true
            self.passwordTextField.isUserInteractionEnabled = true
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        self.view.frame.origin.y = -100
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
