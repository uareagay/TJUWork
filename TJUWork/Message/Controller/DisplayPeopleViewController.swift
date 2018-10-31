//
//  DisplayPeopleViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/20.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


protocol TransmitPeopleInformationProtocol: class {
    func transmit(_ tuples: [(String, String)])
}

class DisplayPeopleViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    
    fileprivate var entireUsersModel: EntireUsersModel!
    fileprivate var mids: [String] = []
    
    fileprivate var peopleArrs: [(String, String)] = []
    
    convenience init(_ model: EntireUsersModel, mids: [String]) {
        self.init()
        self.entireUsersModel = model
        self.mids = mids
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.allowsMultipleSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        self.view.addSubview(tableView)
        //tableView.isEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "收件人列表"
        
        //let searchItem = UIBarButtonItem(title: "搜索发件人", style: .done, target: self, action: #selector(addPeople(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPeople(_:)))
        let forwardItem = UIBarButtonItem(title: "转发消息", style: .done, target: self, action: #selector(forwardMessage(_:)))
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //无效
        //self.navigationController?.toolbarItems = [cancelItem, flexItem, doneItem]
        self.toolbarItems = [flexItem, forwardItem, flexItem]
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
}

extension DisplayPeopleViewController {
    
    @objc func forwardMessage(_ sender: UIBarButtonItem) {
        guard self.peopleArrs.count != 0 else {
            let rvc = UIAlertController(title: nil, message: "请选择收件人", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        let alertVC = UIAlertController(title: "确认转发吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default)
        let saveChangeAction = UIAlertAction(title: "确认", style: .default) { _ in
            let uids = self.peopleArrs.map { $0.0 }
            PersonalMessageHelper.forwardMessage(mids: self.mids, uids: uids, success: {
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                //self.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            }, failure: {
                
            })
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveChangeAction)
        self.present(alertVC, animated: true)
    }
    
    @objc func addPeople(_ sender: UIBarButtonItem) {
        let searchPeopleVC = SearchPeopleViewController(self.entireUsersModel, isForward: true, forwardMessages: self.mids)
        searchPeopleVC.searchDelegate = self
        self.navigationController?.pushViewController(searchPeopleVC, animated: true)
    }
    
}

extension DisplayPeopleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        self.peopleArrs.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .right)
        
        print("fuck")
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
}

extension DisplayPeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 30
        return self.peopleArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELLID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELLID")
        }
        
        cell?.textLabel?.text = self.peopleArrs[indexPath.row].1
        //cell?.detailTextLabel?.text = "学工部"
        return cell!
    }
    
}

extension DisplayPeopleViewController: TransmitPeopleInformationProtocol {
    func transmit(_ tuples: [(String, String)]) {
        for index in 0..<tuples.count {
            let tuple = tuples[index]
            var flag = false
            for i in 0..<self.peopleArrs.count {
                if self.peopleArrs[i].0 == tuple.0 {
                    flag = true
                    break
                }
            }
            if !flag {
                self.peopleArrs.append(tuple)
            }
        }
        self.tableView.reloadData()
    }
}
