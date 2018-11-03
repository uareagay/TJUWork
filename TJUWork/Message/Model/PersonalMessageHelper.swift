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
    
    static func getDraftList(page: Int = 1, success: ((DraftListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/draft/web/list?page=\(page)", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? DraftListModel(data: data) {
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
    
    static func getOutboxList(page: Int = 1, success: ((OutboxListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/web/outbox?page=\(page)", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? OutboxListModel(data: data) {
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
    
    static func getInboxList(page: Int = 1, success: ((InboxListModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/web/inbox?page=\(page)", token: WorkUser.shared.token, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? InboxListModel(data: data) {
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
    
    static func searchInbox(content: String, success: ((InboxSearchModel)->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/message/inbox/search", token: WorkUser.shared.token, parameters: ["content": content], success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? InboxSearchModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "搜索成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "搜索失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "搜索失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "搜索失败")
            }
            failure?()
        })
    }
    
    static func searchOutbox(content: String, success: ((OutboxSearchModel)->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/message/outbox/search", token: WorkUser.shared.token, parameters: ["content": content], success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? OutboxSearchModel(data: data) {
                    //SwiftMessages.showSuccessMessage(title: "搜索成功")
                    success?(model)
                } else {
                    SwiftMessages.showErrorMessage(title: "搜索失败")
                    failure?()
                }
            } else {
                SwiftMessages.showErrorMessage(title: "搜索失败")
                failure?()
            }
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: NetworkManager.errorString)
            } else {
                SwiftMessages.showErrorMessage(title: "搜索失败")
            }
            failure?()
        })
    }
    
    static func getResponsePeoples(mid: String, success: ((ResponsePeopleModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/response/number", token: WorkUser.shared.token, parameters: ["mid": mid], success: { dic in
            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? ResponsePeopleModel(data: data) {
                    //let nameArrs = model.data.finished.map { $0.name }
                    success?(model)
                }
            }
        }, failure: { error in
            
        })
    }
    
    static func getReadPeoples(mid: String, success: ((ReadPeopleModel)->())?, failure: (()->())?) {
        NetworkManager.getInformation(url: "/message/read/number", token: WorkUser.shared.token, parameters: ["mid": mid], success: { dic in
//            print(dic)
            if let status = dic["status"] as? Bool, status == true {
                if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? ReadPeopleModel(data: data) {
                    //let nameArrs = model.data.finished.map { $0.name }
                    success?(model)
                }
            }
        }, failure: { error in
            
        })
    }
    
    static func markRead(mids: [String], success: (()->())?, failure: (()->())?) {
        var dic: [String:String] = [:]
        for i in 0..<mids.count {
            dic["mid[\(i)]"] = mids[i]
        }
        
        NetworkManager.postInformation(url: "/message/read", token: WorkUser.shared.token, parameters: dic, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                success?()
            } else {
                failure?()
            }
        }, failure: { error in
            failure?()
        })
    }
    
    static func markUnRead(mids: [String], success: (()->())?, failure: (()->())?) {
        var dic: [String:String] = [:]
        for i in 0..<mids.count {
            dic["mid[\(i)]"] = mids[i]
        }
        
        NetworkManager.postInformation(url: "/message/unread", token: WorkUser.shared.token, parameters: dic, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                success?()
            } else {
                failure?()
            }
        }, failure: { error in
            failure?()
        })
    }
    
    static func forwardMessage(mids: [String], uids: [String], success: (()->())?, failure: (()->())?) {
        var dic: [String:String] = [:]
        for i in 0..<mids.count {
            dic["mid[\(i)]"] = mids[i]
        }
        for i in 0..<uids.count {
            dic["uid[\(i)]"] = uids[i]
        }
        
        NetworkManager.postInformation(url: "/message/forward", token: WorkUser.shared.token, parameters: dic, success: { dic in
            if let status = dic["status"] as? Bool, status == true {
                SwiftMessages.showSuccessMessage(title: "转发成功")
                success?()
            } else {
                SwiftMessages.showErrorMessage(title: "转发失败")
                failure?()
            }
        }, failure: { error in
            SwiftMessages.showErrorMessage(title: "转发失败")
            failure?()
        })
    }
    
    static func sendConferenceMessage(dictionary: [String:Any], success: (()->())?, failure: (()->())?) {
        NetworkManager.postInformation(url: "/meeting/send", token: WorkUser.shared.token, parameters: dictionary, success: { dic in
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
    
}
