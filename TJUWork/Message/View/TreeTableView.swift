//
//  TreeTableView.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/26.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit


class TreeTableView: UITableView {
    
    var modelDatas: [TreeNode] = []
    var visibleModelDatas: [TreeNode] = []
    var node: TreeNode!
    var usersModel: EntireUsersModel!
    
    var selectedUsers: [String:String] {
        var selectedArrs: [String:String] = [:]
        for i in 0..<modelDatas.count {
            let node = modelDatas[i]
            if node.isChild == true && node.isSelected == true {
                selectedArrs[node.uid] = node.name
            }
        }
        return selectedArrs
    }
    
    init(frame: CGRect, style: UITableViewStyle, _ model: EntireUsersModel) {
        super.init(frame: frame, style: style)
        
        node = TreeNode(name: "非行政单位", ID: 0, parentID: -1, depth: 0, isVisible: true, isExpand: false, isChild: false, isSelected: false, uid: "")
        modelDatas.append(node)
        visibleModelDatas.append(node)
        
        node = TreeNode(name: "行政单位", ID: 1, parentID: -1, depth: 0, isVisible: true, isExpand: false, isChild: false, isSelected: false, uid: "")
        modelDatas.append(node)
        visibleModelDatas.append(node)
        
        node = TreeNode(name: "各学院（部）", ID: 2, parentID: -1, depth: 0, isVisible: true, isExpand: false, isChild: false, isSelected: false, uid: "")
        modelDatas.append(node)
        visibleModelDatas.append(node)
        
        node = TreeNode(name: "学工部", ID: 3, parentID: 1, depth: 1, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
        modelDatas.append(node)
        
        node = TreeNode(name: "校团委", ID: 4, parentID: 1, depth: 1, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
        modelDatas.append(node)
        
        //visibleModelDatas.append(node)
        
        var id: Int = 5
        
        for index in 0..<model.data.count {
            let label = model.data[index]
            if label.type == 0 {
                let name = label.labelName
                if name == "本科生教育科" || name == "本科生管理科" || name == "研究生教育管理科" || name == "心理健康教育中心" || name == "就业指导中心" || name == "学生资助管理中心" || name == "武装部" || name == "学工部长" || name == "园区中心" || name == "教学中心" || name == "学生档案室" {
                    node = TreeNode(name: label.labelName, ID: id, parentID: 3, depth: 2, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
                    modelDatas.append(node)
                    let parID = id
                    id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 3, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                } else if name == "组织部" || name == "宣传部" || name == "权益部" || name == "双创部" || name == "艺术教育中心" || name == "美育部" || name == "校团委书记" {
                    node = TreeNode(name: label.labelName, ID: id, parentID: 4, depth: 2, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
                    modelDatas.append(node)
                    let parID = id
                    id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 3, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                } else {
                    node = TreeNode(name: label.labelName, ID: id, parentID: 0, depth: 1, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
                    modelDatas.append(node)
                    let parID = id
                    id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 2, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                }
            } else {
                let name = label.labelName
                //学院属于行政单位，但是把它独立出来
                if name.hasSuffix("学院") || name.hasSuffix("学部") || name.hasSuffix("研究院") {
                    node = TreeNode(name: label.labelName, ID: id, parentID: 2, depth: 1, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
                    modelDatas.append(node)
                    let parID = id
                    id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 2, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                } else if name == "学工部" {
                    //let parID = id
                    let parID = 3
                    //id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 2, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                } else if name == "校团委" {
                    let parID = 4
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 2, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                } else {
                    node = TreeNode(name: label.labelName, ID: id, parentID: 1, depth: 1, isVisible: false, isExpand: false, isChild: false, isSelected: false, uid: "")
                    modelDatas.append(node)
                    let parID = id
                    id += 1
                    for i in 0..<label.users.count {
                        let user = label.users[i]
                        node = TreeNode(name: user.realName, ID: id, parentID: parID, depth: 2, isVisible: false, isExpand: false, isChild: true, isSelected: false, uid: String(user.uid))
                        modelDatas.append(node)
                        id += 1
                    }
                }
                
            }
        }
        
        self.delegate = self
        self.dataSource = self
        self.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTableViewCell")
        self.rowHeight = 25
        self.allowsSelection = false
        self.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TreeTableView {
    
    func changeSelectedState(parentNodePos: IndexPath, state: Bool) {
        let parentNode = visibleModelDatas[parentNodePos.row]
        
        traverseChildNode(parentID: parentNode.ID, state: state)
        traverseParentNode(parentID: parentNode.parentID, state: state)
        
        self.reloadData()
    }
    
    func traverseParentNode(parentID: Int, state: Bool) {
        guard parentID != -1 else {
            return
        }
        
        var isSameState = true
        for i in 0..<modelDatas.count {
            let node = modelDatas[i]
            guard node.parentID == parentID else {
                continue
            }
            if state != node.isSelected {
                isSameState = false
                break
            }
        }
        
        for i in 0..<modelDatas.count {
            let node = modelDatas[i]
            guard node.ID == parentID else {
                continue
            }
            if isSameState {
                node.isSelected = state
                traverseParentNode(parentID: node.parentID, state: state)
            } else {
                guard node.isSelected == true else {
                    return
                }
                node.isSelected = false
                traverseParentNode(parentID: node.parentID, state: false)
            }
            break
        }
        
    }
    
    func traverseChildNode(parentID: Int, state: Bool) {
        
        for i in 0..<modelDatas.count {
            let node = modelDatas[i]
            guard node.parentID == parentID else {
                continue
            }
            node.isSelected = state
            traverseChildNode(parentID: node.ID, state: state)
        }
    }
    
    
    func removeAllChildrenNodesAtParentNode(parentNodePos: IndexPath) -> Int {
        let parentNode = visibleModelDatas[parentNodePos.row]
        let startPos = parentNodePos.row
        var endPos = startPos
        
        for i in startPos+1..<visibleModelDatas.count {
            let node = visibleModelDatas[i]
            endPos += 1
            if node.depth <= parentNode.depth {
                break
            }
            if endPos == visibleModelDatas.count - 1 {
                endPos += 1
            }
            node.isVisible = false
            node.isExpand = false
        }
        
        if endPos - startPos > 1 {
            visibleModelDatas.removeSubrange(startPos+1..<endPos)
        }
        
        return endPos
        
    }
}

extension TreeTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNode = visibleModelDatas[indexPath.row]
        
        let startPos = indexPath.row + 1
        var endPos = startPos
        var isExpand = false
        
        for i in 0..<modelDatas.count {
            
            let node = modelDatas[i]
            guard node.parentID == selectedNode.ID else {
                continue
            }
            
            node.isVisible = !node.isVisible
            
            if node.isVisible == true {
                visibleModelDatas.insert(node, at: endPos)
                endPos += 1
                isExpand = true
                
            } else {
                isExpand = false
                endPos = self.removeAllChildrenNodesAtParentNode(parentNodePos: indexPath)
                break
            }
        }
        
        var indexPathArrs: [IndexPath] = []
        for i in startPos..<endPos {
            indexPathArrs.append(IndexPath(row: i, section: 0))
        }
        
        if isExpand {
            self.insertRows(at: indexPathArrs, with: .automatic)
        } else {
            self.deleteRows(at: indexPathArrs, with: .automatic)
        }
        
    }
    
}

extension TreeTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleModelDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        let node = visibleModelDatas[indexPath.row]
        
        if node.isChild == true {
            cell.expandBtn.isHidden = true
        } else {
            cell.expandBtn.isHidden = false
        }
        
        cell.isExpand = node.isExpand
        cell.isAdd = node.isSelected
        
        cell.nameLabel.text = node.name
        cell.selectBtn.frame = CGRect(x: 10+CGFloat.init(node.depth*20), y: 0, width: 25, height: 25)
        cell.expandBtn.frame = CGRect(x: 35+CGFloat.init(node.depth*20), y: 0, width: 25, height: 25)
        cell.nameLabel.frame = CGRect(x: 60+CGFloat.init(node.depth*20), y: 0, width: cell.frame.size.width-60-CGFloat.init(node.depth*20), height: 25)
        
        cell.expandBtn.addTarget(self, action: #selector(clickExpandBtn(_:)), for: .touchUpInside)
        cell.selectBtn.addTarget(self, action: #selector(clickSelectBtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
}

extension TreeTableView {
    
    @objc func clickExpandBtn(_ sender: UIButton) {
        
        let selectedCell = sender.superview?.superview as! ContactTableViewCell
        let selectedRow = self.indexPath(for: selectedCell)?.row
        
        guard selectedRow != nil else {
            return
        }
        
        let selectedNode = visibleModelDatas[selectedRow!]
        
        guard selectedNode.isChild != true else {
            return
        }
        
        selectedNode.isExpand = !selectedNode.isExpand
        selectedCell.isExpand = selectedNode.isExpand
        
        self.tableView(self, didSelectRowAt: self.indexPath(for: selectedCell)!)
    }
    
    @objc func clickSelectBtn(_ sender: UIButton) {
        
        let selectedCell = sender.superview?.superview as! ContactTableViewCell
        let selectedRow = self.indexPath(for: selectedCell)?.row
        
        guard selectedRow != nil else {
            return
        }
        
        let selectedNode = visibleModelDatas[selectedRow!]
        
        selectedNode.isSelected = !selectedNode.isSelected
        selectedCell.isAdd = selectedNode.isSelected
        
        changeSelectedState(parentNodePos: IndexPath(row: selectedRow!, section: 0), state: selectedNode.isSelected)
    }
    
}
