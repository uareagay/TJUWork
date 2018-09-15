//
//  UserInfoHelper.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/7.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages

struct UserInfoHelper {
    
    static func uploadAvatar(dictionary: [String:Any], success: (()->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/user/avatar", token: WorkUser.shared.token, parameters: dictionary, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                SwiftMessages.showSuccessMessage(title: "上传头像成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "上传头像失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "上传头像失败")
            }
            failure?()
        })
        
    }
    
    static func uploadUserInfo(dictionary: [String:Any], success: (()->())?, failure: (()->())?) {
        
        NetworkManager.postInformation(url: "/user/edit", token: WorkUser.shared.token, parameters: dictionary, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true, let code = dic["code"] as? Int, code == 200 {
                SwiftMessages.showSuccessMessage(title: "信息修改成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "信息修改失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "信息修改失败")
            }
            failure?()
        })
        
    }
    
}
