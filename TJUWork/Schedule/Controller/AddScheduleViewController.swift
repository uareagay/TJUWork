//
//  AddScheduleViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/11.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class AddScheduleViewController: UIViewController {
    
    
//    fileprivate var textView: UITextView = {
//        let textView = UITextView()
//        textView.text = "编辑内容"
//        textView.textColor = .lightGray
//        textView.backgroundColor = .white
//        textView.isUserInteractionEnabled = true
//        textView.isScrollEnabled = true
//        textView.font = UIFont.systemFont(ofSize: 15)
//        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        return textView
//    }()
    
//    fileprivate let datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
//        datePicker.locale = Locale(identifier: "zh_CN")
//        return datePicker
//    }()
    
//    var HTMLString: String = ""
    
    
    fileprivate var messageTitle: String {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleTableViewCell {
            return cell.textField.text ?? ""
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as? TitleTableViewCell {
            return cell.textField.text ?? ""
        }
        return ""
    }
    
    fileprivate var messageDeadline: String {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DeadlineTableViewCell {
            return cell.dateLabel.text ?? ""
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "DeadlineTableViewCell") as? DeadlineTableViewCell {
            return cell.dateLabel.text ?? ""
        }
        return ""
    }
    
    fileprivate var tableView: UITableView!
    
    fileprivate let sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("添加日程", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
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
        tableView.rowHeight = 55
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: "DeadlineTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
        sendBtn.addTarget(self, action: #selector(addCalendarAction(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "添加日程"
    }
    
}

extension AddScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineTableViewCell") as! DeadlineTableViewCell
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
            let doneItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(toolBarCancelAction(_:)))
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [flexItem, doneItem]
            cell.dateLabel.inputAccessoryView = toolBar
            
            return cell
        }
    }
    
}

extension AddScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "添加事件"
        } else {
            return "添加时间"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        
        view.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        return view
    }
    
}

extension AddScheduleViewController {
    
    @objc func toolBarCancelAction(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
        self.tableView.isUserInteractionEnabled = true
    }
    
    @objc func addCalendarAction(_ sender: UIButton) {
//        guard title != "" && self.HTMLString != ""  else {
//            let rvc = UIAlertController(title: nil, message: "标题和内容不能为空", preferredStyle: .alert)
//            self.present(rvc, animated: true, completion: nil)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
//                self.presentedViewController?.dismiss(animated: true, completion: nil)
//            })
//            return
//        }
        
        let title = self.messageTitle
        let deadlineDate = self.messageDeadline
        
        guard title != "",  deadlineDate != "" else {
            let rvc = UIAlertController(title: nil, message: "标题和内容不能为空", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        self.tableView.isUserInteractionEnabled = false
        
        ScheduleHelper.addCalendar(title: title, to: deadlineDate, className: "个人", success: {
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            self.navigationController?.popViewController(animated: true)
        }, failure: {
            self.tableView.isUserInteractionEnabled = true
        })
        
    }
    
}

