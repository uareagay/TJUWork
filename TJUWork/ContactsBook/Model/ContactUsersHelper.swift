//
//  ContactUsersHelper.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/28.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages


struct ContactUsersHelper {
    
    static func getContactUsers(success: ((ContactUsersModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/user/contact/users", token: WorkUser.shared.token, success: { dic in

            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? ContactUsersModel(data: data) {
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取联系人列表失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取联系人列表失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取联系人列表失败")
            }
            failure?()
        })
    }
    
}
