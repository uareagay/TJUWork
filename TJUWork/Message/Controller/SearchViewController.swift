//
//  SearchViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/20.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class SearchViewController: UIViewController {
    
    enum SearchType {
        case inbox  //收件箱
        case outbox //发件箱
    }
    
    fileprivate let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        //searchBar.showsScopeBar = false
        searchBar.tintColor = UIColor(hex6: 0x00518e)
        searchBar.placeholder = "搜索"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.init(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        }
        return searchBar
    }()
    
    fileprivate var tableView: UITableView!
    fileprivate var currentPage: Int = 0
    
    
    convenience init(_ type: SearchType) {
        self.init(nibName: nil, bundle: nil)
        
        switch type {
        case .inbox:
            self.searchBar.placeholder = "收件箱搜索"
        case .outbox:
            self.searchBar.placeholder = "发件箱搜索"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        self.searchBar.delegate = self
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = "消息"
        
        //取消返回按钮
        //self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSearch(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
    }
    
}

extension SearchViewController {
    
    @objc func cancelSearch(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = self.searchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            searchMessage(with: searchText)
        }
    }
    
    
    
}

extension SearchViewController {
    
    func searchMessage(with keyword: String) {
        
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
