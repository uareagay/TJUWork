//
//  ScheduleHelper.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/25.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages


struct ScheduleHelper {
    
    static func getCalendarList(success: ((ScheduleListsModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/calender/list", token: WorkUser.shared.token, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? ScheduleListsModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "获取日历列表成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取日历列表失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取日历列表失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取日历列表失败")
            }
            failure?()
        })
    }
    
    
}

