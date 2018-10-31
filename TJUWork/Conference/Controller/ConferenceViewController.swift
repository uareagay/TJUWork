//
//  ConferenceViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/31.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation

class ConferenceViewController: UIViewController {
    fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "会议记录"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addConference(_:)))
    }
    
    @objc func addConference(_ sender: UIBarButtonItem) {
        let addVC = AddConferenceViewController()
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}
