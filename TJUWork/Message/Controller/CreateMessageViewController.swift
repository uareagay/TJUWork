//
//  CreateMessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/26.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class CreateMessageViewController: UIViewController {
    
    var treeTableView: TreeTableView!
    
    var tableView: UITableView!
    
    var pickerView: UIPickerView!
    
    fileprivate var selectedCampus: String = ""
    
    let emptyView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .lightGray
        return view
    }()
    
    let popView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        guard UIScreen.main.bounds.height == 812 else {
            view.frame = CGRect(x: 35, y: 85, width: UIScreen.main.bounds.width-70, height: UIScreen.main.bounds.height-85-75)
            return view
        }
        view.frame = CGRect(x: 35, y: 100, width: UIScreen.main.bounds.width-70, height: UIScreen.main.bounds.height-100-110)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        treeTableView = TreeTableView(frame: self.view.bounds, style: .grouped)
//        self.view.addSubview(treeTableView)
//        treeTableView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(40)
//            make.top.bottom.equalToSuperview().inset(85)
//        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTreeTableView(_:)))
        tapGestureRecognizer.delegate = self
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
       
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.allowsSelection = false
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(MessageNameTableViewCell.self, forCellReuseIdentifier: "MessageNameTableViewCell")
        tableView.register(ReceiverTableViewCell.self, forCellReuseIdentifier: "ReceiverTableViewCell")
        tableView.register(MessageCategoryTableViewCell.self, forCellReuseIdentifier: "MessageCategoryTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "新建消息"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        cell.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: false)
    }
    
    @objc func toolBarCancelAction(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func toolBarDoneAction(_ button: UIBarButtonItem) {
        print(pickerView.selectedRow(inComponent: 0))
        self.view.endEditing(true)
    }
    
}

extension CreateMessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0 else {
            return 200
        }
        return 55
    }
    
}

extension CreateMessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageNameTableViewCell") as! MessageNameTableViewCell
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
            let cancelItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(toolBarCancelAction(_:)))
            let doneItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(toolBarDoneAction(_:)))
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [cancelItem, flexItem, doneItem]
            
            let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.frame.size.height+44))
            pickerView.frame = CGRect(x: 0, y: 44, width: inputView.frame.size.width, height: inputView.frame.size.height-44)
            inputView.backgroundColor = .clear
            inputView.addSubview(pickerView)
            inputView.addSubview(toolBar)
            
            cell.collegeLabel.inputView = inputView
            
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
            cell.delegate = self
            
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCategoryTableViewCell") as! MessageCategoryTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension CreateMessageViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "fuck"
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }
    
}

extension CreateMessageViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

}

extension CreateMessageViewController: AddAndDeleteReceiverProtocol {
    func deleteReceiverCell(_ indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        
        cell.collectionView.deleteItems(at: [indexPath])
        
    }
    
    func addReceiverCell(_ extraDatas: [String]) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        let oldCounts = cell.datas.count
        cell.datas.append(contentsOf: extraDatas)
        
        var indexPaths: [IndexPath] = []
        for i in 0..<extraDatas.count {
            indexPaths.append(IndexPath(row: oldCounts+i, section: 0))
        }
        cell.collectionView.insertItems(at: indexPaths)
    }
    
    func presentTreeTableView() {
        emptyView.addSubview(popView)
        self.view.addSubview(emptyView)
    }
    
    
}

extension CreateMessageViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.emptyView)
        guard self.popView.frame.contains(touchPoint) else {
            return false
        }
        return true
    }
    
    @objc func dismissTreeTableView(_ sender: UIButton) {
        
    }
    
}
