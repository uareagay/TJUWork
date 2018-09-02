//
//  MessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/15.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class MessageViewController: UIViewController {
    
    var tableView: UITableView!
    var menuView: DownMenuView!
    
    var selectedArrs: [Int] = []
    var isSelecting: Bool = false
    
    let menuBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-40-10, y: 0, width: 80, height: 50))
        btn.setTitle("收件箱", for: .normal)
        btn.setTitleColor(UIColor(hex6: 0x00518e), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return btn
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30, y: UIScreen.main.bounds.size.height-130, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "删除")!, scaledToWidth: 60.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 65
        tableView.separatorStyle = .none
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenuView(_:)))
        hideGesture.delegate = self
        hideGesture.delaysTouchesBegan = true
        tableView.addGestureRecognizer(hideGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEditing(_:)))
        longPress.minimumPressDuration = 1.0
        longPress.name = "LongPress"
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPress)
        
        
        menuBtn.addTarget(self, action: #selector(clickMenuBtn(_:)), for: .touchUpInside)
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
       
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        menuView = DownMenuView(frame: CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0))
        menuView.layer.borderColor = UIColor.gray.cgColor
        menuView.layer.borderWidth = 0.2
        menuView.layer.shadowColor = UIColor.gray.cgColor
        menuView.layer.shadowOpacity = 0.8
        menuView.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuView.delegate = self
        self.view.addSubview(menuView)
        
        
        self.view.addSubview(deleteBtn)
        
    }
    
    @objc func longPressEditing(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            
            
            
            let pressPoint = gesture.location(in: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: pressPoint) {
                
                isSelecting = true
                
                self.deleteBtn.alpha = 1.0
                
                selectedArrs.append(indexPath.section)
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    @objc func dismissMenuView(_ gesture: UITapGestureRecognizer) {
        print("dismiss")
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        UIView.animate(withDuration: 0.25, animations: {
            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            self.menuView.hideMenuView()
        })
        menuBtn.isSelected = false
        tableView.isScrollEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "消息"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc func clickMenuBtn(_ sender: UIButton) {
        
        print(menuBtn.isSelected)
        
        if menuBtn.isSelected == false {
        
            tableView.isScrollEnabled = false
            
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
            menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            self.view.bringSubview(toFront: menuView)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 32.5*3)
            })
            self.menuView.showMenuView()
            
            
            menuBtn.isSelected = true
        } else {
            
            tableView.isScrollEnabled = true
            
            let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
            UIView.animate(withDuration: 0.25, animations: {
                self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
            })
            self.menuView.hideMenuView()
            menuBtn.isSelected = false
        }
        
    }
    
    
}

extension MessageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

//        let touchPoint = touch.location(in: self.view)
//        let btnRect = menuBtn.convert(menuBtn.bounds, to: self.view)
//        let viewRect = menuView.convert(menuView.bounds, to: self.view)
//        if btnRect.contains(touchPoint) || viewRect.contains(touchPoint) {
//            print("qaz")
//            return false
//        }
//        print("vv")
//        return true

        
        if self.menuBtn.isSelected == true {
            if gestureRecognizer.name == "LongPress" {
                
                gestureRecognizer.setValue(3, forKey: "state")
                
                return true
            }
            return true
        } else {
            if gestureRecognizer.name == "LongPress" {
                return true
            }
            return false
        }


    }
    
    
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 65))
        view.backgroundColor = .clear
        let contenView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        contenView.backgroundColor = .white
        contenView.layer.masksToBounds = true
        contenView.layer.cornerRadius = 10
        
        let addBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width-20-50, y: 0, width: 50.0, height: 50.0))
        addBtn.setImage(UIImage.resizedImage(image: UIImage(named: "新建消息")!, scaledToWidth: 45.0), for: .normal)
        
        
        view.addSubview(contenView)
        contenView.addSubview(menuBtn)
        contenView.addSubview(addBtn)
        
        contenView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }

        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 0
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard isSelecting == true else {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
        
        if let index = selectedArrs.index(of: indexPath.section) {
            selectedArrs.remove(at: index)
            cell.imgView.image = cell.unselectedImg
        } else {
            selectedArrs.append(indexPath.section)
            cell.imgView.image = cell.selectedImg
        }
        
        //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("SS")
    }
    
    
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        
        guard isSelecting == true else {
            return cell
        }
        
        if selectedArrs.contains(indexPath.section) {
            cell.imgView.image = cell.selectedImg
        } else {
            cell.imgView.image = cell.unselectedImg
        }
        
        return cell
    }
}

extension MessageViewController: DropDownDelegate {
    func didSelectCell(_ number: Int) {
        
        let rect = self.menuBtn.convert(self.menuBtn.bounds, to: self.view)
        UIView.animate(withDuration: 0.25, animations: {
            self.menuView.frame = CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height+5, width: rect.size.width, height: 0)
        })
        self.menuView.hideMenuView()
        self.menuBtn.isSelected = false
        self.tableView.isScrollEnabled = true
    }
}
