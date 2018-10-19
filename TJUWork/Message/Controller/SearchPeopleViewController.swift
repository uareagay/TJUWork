//
//  SearchPeopleViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/16.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation
import SnapKit

class SearchPeopleViewController: UIViewController {
    
    var topConstraint: Constraint?
    //fileprivate var entireUsersModel: EntireUsersModel!
    fileprivate var displayUsersTuple: [(String, String)] = []
    fileprivate var entireUsersTuple: [(String, String)] = []
    fileprivate var tableView: UITableView!
    fileprivate let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: 44))
        searchBar.tintColor = UIColor(hex6: 0x00518e)
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.placeholder = "搜索收件人"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.init(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        }
        return searchBar
    }()
    
    weak var delegate: AddAndDeleteReceiverProtocol?
    weak var searchDelegate: TransmitPeopleInformationProtocol?
    
    fileprivate var isForward: Bool = false
    fileprivate var forwardMessages: [String] = []
    
    convenience init(_ model: EntireUsersModel, isForward: Bool = false, forwardMessages: [String] = []) {
        self.init()
        
        self.isForward = isForward
        self.forwardMessages = forwardMessages
        
        var dic: [String:String] = [:]
        for index in 0..<model.data.count {
            let label = model.data[index]
            for i in 0..<label.users.count {
                let user = label.users[i]
                dic[user.uid] = user.realName
            }
        }
        for keyValue in dic {
            self.entireUsersTuple.append((keyValue.key, keyValue.value))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        //tableView.allowsMultipleSelection = true
        tableView.allowsSelection = false
        //tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.tintColor = UIColor(hex6: 0x00518e)
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            self.topConstraint = make.top.equalToSuperview().inset(140).constraint
        }
        
        self.view.addSubview(self.searchBar)
        
        self.searchBar.delegate = self
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "选择收件人"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择", style: .plain, target: self, action: #selector(enterEditStyle(_:)))
        
        let addItem = UIBarButtonItem(title: "添加收件人", style: .done, target: self, action: #selector(addPeople(_:)))
        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //无效
        //self.navigationController?.toolbarItems = [cancelItem, flexItem, doneItem]
        self.toolbarItems = [flexItem, addItem, flexItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
}

extension SearchPeopleViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = self.searchBar.text {
            searchMessage(text)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelEditStyle(_:)))
        self.tableView.setEditing(true, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.searchBar.resignFirstResponder()
        self.searchBar.isHidden = true
        self.topConstraint?.update(inset: 64)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMessage(searchText)
    }
    
    
}

extension SearchPeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayUsersTuple.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELLID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELLID")
        }
        
        cell?.textLabel?.text = self.displayUsersTuple[indexPath.row].1
        return cell!
    }
    
}

extension SearchPeopleViewController {
    
    @objc func enterEditStyle(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelEditStyle(_:)))
        self.tableView.setEditing(true, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.searchBar.resignFirstResponder()
        self.searchBar.isHidden = true
        self.topConstraint?.update(inset: 64)
    }
    
    @objc func cancelEditStyle(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择", style: .plain, target: self, action: #selector(enterEditStyle(_:)))
        self.tableView.setEditing(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.searchBar.isHidden = false
        self.topConstraint?.update(inset: 140)
    }
    
    @objc func addPeople(_ sender: UIBarButtonItem) {
        guard let indexPaths = self.tableView.indexPathsForSelectedRows else {
            let rvc = UIAlertController(title: nil, message: "请选择收件人", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        guard !self.isForward else {
//            let uids = indexPaths.map { self.displayUsersTuple[$0.row].0 }
            
            let tuples = indexPaths.map {
                (self.displayUsersTuple[$0.row].0, self.displayUsersTuple[$0.row].1)
            }
            
            searchDelegate?.transmit(tuples)
            
//            PersonalMessageHelper.forwardMessage(mids: self.forwardMessages, uids: uids, success: {
//                NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//                NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
//                self.navigationController?.popToRootViewController(animated: true)
//            }, failure: {
//
//            })
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        var dic: [String:String] = [:]
        for indexPath in indexPaths {
            let tuple = self.displayUsersTuple[indexPath.row]
            dic[tuple.0] = tuple.1
        }
        
        delegate?.addReceiverCell!(uids: dic)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchMessage(_ text:String) {
        guard text.count != 0 else {
            return
        }
        
        self.displayUsersTuple = self.entireUsersTuple.filter {
            return $0.1.contains(text)
        }
        self.tableView.reloadData()
    }
    
}
