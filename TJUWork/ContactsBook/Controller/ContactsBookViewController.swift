//
//  ContactsBookViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/28.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit
import ContactsUI


class ContactsBookViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    //fileprivate var phoneBook: [ContactUsersData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.allowsSelection = false
        tableView.register(PhoneTableViewCell.self, forCellReuseIdentifier: "PhoneTableViewCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        PhoneBook.shared.getPhoneNumber(success: {
            self.tableView.reloadData()
        }, failure: {
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "联系人列表"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearching(_:)))
        self.navigationController?.navigationBar.tintColor = .white
    }
}

extension ContactsBookViewController {
    @objc func clickSearching(_ sender: UIButton) {
        let searchVC = SearchContactUsersViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func phoneTapped(_ sender: UIButton) {
//        guard let phone = PhoneBook.shared.items[sender.tag].phone else {
//            return
//        }
        guard let phone = PhoneBook.shared.itemArrs[sender.tag].phone else {
            return
        }

        if let url = URL(string: "telprompt://\(phone)") {
            UIApplication.shared.open(url)
        }
    }
    
}

extension ContactsBookViewController: UITableViewDelegate {
    
}

extension ContactsBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return PhoneBook.shared.items.count
        return PhoneBook.shared.itemArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneTableViewCell") as! PhoneTableViewCell
        cell.nameLabel.text = PhoneBook.shared.itemArrs[indexPath.row].name
        cell.academyLabel.text = PhoneBook.shared.itemArrs[indexPath.row].academy
        
        //要改一下
//        if let phone = PhoneBook.shared.items[indexPath.row].phone, phone.count == 11 {
//            cell.isPhoned = true
//            cell.phoneLabel.text = phone
//        } else {
//            cell.isPhoned = false
//        }
        
        if let phone = PhoneBook.shared.itemArrs[indexPath.row].phone, phone.count == 11 {
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
