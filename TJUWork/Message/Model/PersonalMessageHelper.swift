//
//  PersonalMessageHelper.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/10.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages

struct PersonalMessageHelper {
    
    static func sendMessage(dictionary: [String:Any], success: (()->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/message/send", token: WorkUser.shared.token, parameters: dictionary, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                SwiftMessages.showSuccessMessage(title: "发送成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "发送失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "发送失败")
            }
            failure?()
        })
        
    }
    
    static func saveDraft(dictionary: [String:Any], success: (()->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/draft/save", token: WorkUser.shared.token, parameters: dictionary, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                SwiftMessages.showSuccessMessage(title: "存至草稿箱成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "存至草稿箱失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "存至草稿箱失败")
            }
            failure?()
        })
        
    }
    
    static func deleteDraft(did: [Int], success: (()->())?, failure: (()->())?) {
        
        var dic: [String:String] = [:]
        for i in 0..<did.count {
            dic["did[\(i)]"] = String(did[i])
        }
        
        NetworkManager.postInformation(url: "/draft/delete", token: WorkUser.shared.token, parameters: dic, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                //SwiftMessages.showSuccessMessage(title: "删除草稿成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "删除草稿失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "删除草稿失败")
            }
            failure?()
        })
    }
    
    static func deleteInbox(mid: [Int], success: (()->())?, failure: (()->())?) {
        
        var dic: [String:String] = [:]
        for i in 0..<mid.count {
            dic["mid[\(i)]"] = String(mid[i])
        }
        
        NetworkManager.postInformation(url: "/message/inbox/delete", token: WorkUser.shared.token, parameters: dic, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                //SwiftMessages.showSuccessMessage(title: "删除收件成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "删除收件失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "删除收件失败")
            }
            failure?()
        })
    }
    
    static func deleteOutbox(mid: [Int], success: (()->())?, failure: (()->())?) {
        
        var dic: [String:String] = [:]
        for i in 0..<mid.count {
            dic["mid[\(i)]"] = String(mid[i])
        }
        
        NetworkManager.postInformation(url: "/message/outbox/delete", token: WorkUser.shared.token, parameters: dic, success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                //SwiftMessages.showSuccessMessage(title: "删除发件成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "删除发件失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "删除发件失败")
            }
            failure?()
        })
    }
    
    static func getDraftList(success: ((DraftListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/draft/list", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? DraftListModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "获取草稿列表成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取草稿列表失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取草稿列表失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取草稿列表失败")
            }
            failure?()
        })
    }
    
    static func getOutboxList(success: ((OutboxListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/outbox", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? OutboxListModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "获取发件列表成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取发件列表失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取发件列表失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取发件列表失败")
            }
            failure?()
        })
    }
    
    static func getInboxList(success: ((InboxListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/inbox", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? InboxListModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "获取收件列表成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取收件列表失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取收件列表失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取收件列表失败")
            }
            failure?()
        })
    }
    
    static func getCalendarList(success: ((WorkCalendarModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/calender", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? WorkCalendarModel(data: data) {
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
    
    static func getDetailMessage(mid: String, success: ((DetailMessageModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/detail", token: WorkUser.shared.token, parameters: ["mid":mid], success: { dic in
            
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? DetailMessageModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "获取消息详情成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "获取消息详情失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "获取消息详情失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "获取消息详情失败")
            }
            failure?()
        })
    }
    
    
    
    
}