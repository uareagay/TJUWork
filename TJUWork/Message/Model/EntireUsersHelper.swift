//
//  EntireUsersHelper.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/8.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages

struct EntireUsersHelper {
    
    static func getEntireUsersInLabels(success: ((EntireUsersModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/user/contact/labels", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? EntireUsersModel(data: data) {
                    success?(model)
                } else {
                    failure?()
                }
            } else {
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            }
            failure?()
        })
    }
    
    
    static func getEntireLabels(success: ((EntireLabelsModel)->())?, failure: (()->())?) {
        
        NetworkManager.getInformation(url: "/label/show", token: WorkUser.shared.token,success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? EntireLabelsModel(data: data) {
                    success?(model)
                } else {
                    failure?()
                }
            } else {
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            }
            failure?()
        })
        
    }
    
    
}
