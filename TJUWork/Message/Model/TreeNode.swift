//
//  TreeNode.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/26.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

class TreeNode {
    
    var name: String
    var ID: Int
    var parentID: Int
    var depth: Int
    var isVisible: Bool
    var isExpand: Bool
    let isChild: Bool
    var isSelected: Bool
    let uid: String
    
    init(name: String, ID: Int, parentID: Int, depth: Int, isVisible: Bool, isExpand: Bool, isChild: Bool, isSelected: Bool, uid: String) {
        self.name = name
        self.ID = ID
        self.parentID = parentID
        self.depth = depth
        self.isVisible = isVisible
        self.isExpand = isExpand
        self.isChild = isChild
        self.isSelected = isSelected
        self.uid = uid
    }
}
