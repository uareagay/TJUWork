//
//  SearchContactUsersViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/29.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit

class SearchContactUsersViewController: UIViewController {
    fileprivate let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        searchBar.tintColor = UIColor(hex6: 0x00518e)
        searchBar.placeholder = "搜索联系人"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.init(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        }
        return searchBar
    }()
    
    fileprivate var tableView: UITableView!
    fileprivate var resultArrs: [(name: String, phone: String?, academy: String?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(PhoneTableViewCell.self, forCellReuseIdentifier: "PhoneTableViewCell")
        tableView.rowHeight = 65
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
        self.view.backgroundColor = .white
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "搜索联系人"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSearch(_:)))
    }
}

extension SearchContactUsersViewController {
    @objc func cancelSearch(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchMessage(_ keyword: String) {
        guard keyword.count > 0 else {
            return
        }
        
        self.resultArrs = PhoneBook.shared.getSearchResult(keyword)
        self.tableView.reloadData()
    }
    
    @objc func phoneTapped(_ sender: UIButton) {
        guard let phone = self.resultArrs[sender.tag].phone else {
            return
        }
        
        if let url = URL(string: "telprompt://\(phone)") {
            UIApplication.shared.open(url)
        }
    }
}

extension SearchContactUsersViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = self.searchBar.text {
            searchMessage(text)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMessage(searchText)
    }
}

extension SearchContactUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 250
    }
}

extension SearchContactUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneTableViewCell") as! PhoneTableViewCell
        cell.nameLabel.text = self.resultArrs[indexPath.row].name
        cell.academyLabel.text = self.resultArrs[indexPath.row].academy
        
        //要改一下
        if let phone = self.resultArrs[indexPath.row].phone, phone.count == 11 {
            cell.isPhoned = true
            cell.phoneLabel.text = phone
        } else {
            cell.isPhoned = false
        }
        
        cell.phoneBtn.tag = indexPath.row
        cell.phoneBtn.addTarget(self, action: #selector(phoneTapped(_:)), for: .touchUpInside)
        return cell
    }
}
