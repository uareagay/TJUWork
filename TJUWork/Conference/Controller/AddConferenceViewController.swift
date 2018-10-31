//
//  AddConferenceViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/31.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit

class AddConferenceViewController: UIViewController {
    fileprivate var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "发起会议"
    }
}

extension AddConferenceViewController: UITableViewDelegate {
    
}

extension AddConferenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
