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
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "用户名："
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "密码 ："
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        return label
    }()

    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .next
        //textField.placeholder = "用户"
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        //textField.placeholder = "密码"
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        return textField
    }()

    let loginBtn: UIButton = {
        
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
        
        self.view.addSubview(tjuImageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginBtn)
        
        loginBtn.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let aview = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        view.backgroundColor = .red
//        aview.backgroundColor = .yellow
//        usernameTextField.leftViewMode = .always
//        usernameTextField.rightViewMode = .always
//        usernameTextField.leftView = view
//        usernameTextField.rightView = aview
//        //usernameTextField.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 20, height: 20))
    
        tjuImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.width/3-60)
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
            make.width.equalTo(UIScreen.main.bounds.width*2.2/5)
            make.height.equalTo(UIScreen.main.bounds.width*2/15)
            make.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/5)
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        self.view.backgroundColor = .white
        
    }
    

    @objc func login(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            SwiftMessages.show {
                let view = MessageView.viewFromNib(layout: .cardView)
                view.configureContent(title: "", body: "请填写用户名")
                view.button?.isHidden = true
                view.configureTheme(Theme.error)
                return view
            }
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            SwiftMessages.show {
                let view = MessageView.viewFromNib(layout: .cardView)
                view.configureContent(title: "请填写密码", body: "")
                view.button?.isHidden = true
                view.configureTheme(Theme.error)
                return view
            }
            return
        }
        
        loginBtn.isEnabled = false
        
        
        AccountManager.getToken(username: username, password: password, success: { token in
            WorkUser.shared.token = token
            WorkUser.shared.name = username
            WorkUser.shared.password = password
            print("成功 \(WorkUser.shared.name)")
            print(WorkUser.shared.token)
            WorkUser.shared.save()
            
            self.loginBtn.isEnabled = true
            self.present(MainTanBarController(), animated: true, completion: {
                SwiftMessages.show {
                    let view = MessageView.viewFromNib(layout: .cardView)
                    view.configureContent(title: "登录成功", body: "")
                    view.button?.isHidden = true
                    view.configureTheme(.success)
                    return view
                }
            })
        }, failure: { errorMeg in
            SwiftMessages.show {
                let view = MessageView.viewFromNib(layout: .cardView)
                view.configureContent(title: "登录失败", body: "")
                view.button?.isHidden = true
                view.configureTheme(Theme.error)
                return view
            }
            self.loginBtn.isEnabled = true
        })
        
        
        //self.present(MainTanBarController(), animated: true, completion: nil)
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
