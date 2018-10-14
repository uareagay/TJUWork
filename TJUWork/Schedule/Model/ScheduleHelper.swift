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
    
    static func deleteCalendarList(idArrs: [String], typeArrs: [String], success: (()->())?, failure: (()->())?) {
        var dic: [String:String] = [:]
        for i in 0..<idArrs.count {
            dic["id[\(i)]"] = idArrs[i]
        }
        for i in 0..<typeArrs.count {
            dic["type[\(i)]"] = typeArrs[i]
        }
        
        NetworkManager.postInformation(url: "/calender/delete", token: WorkUser.shared.token, parameters: dic, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "删除日历失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "删除日历失败")
            }
            failure?()
        })
    }
    
    static func addCalendar(title: String, to: String, className: String, success: (()->())?, failure: (()->())?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd   HH:mm"
        let from = formatter.string(from: Date())
        print(from)
        let dic: [String:String] = ["title": title, "class_name": className, "to": to, "from": from]
        
        NetworkManager.postInformation(url: "/calender/create", token: WorkUser.shared.token, parameters: dic, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "添加日历失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "添加日历失败")
            }
            failure?()
        })
    }
    
    
}

