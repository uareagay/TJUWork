//
//  WorkUser.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


fileprivate let queue = DispatchQueue(label: "com.tjuwork.cache")
class WorkUser: Codable {
    
    static var shared = WorkUser()
    private init() {}
    
    var token: String?
    
    var username: String = ""
    var password: String = ""
    var clientID: String?
    
    //var ID: String = ""
    //var email: String = ""
    //var picture: String = ""
    //var payNumber: String = ""
    //var wechat: String = ""
    //var phone: String = ""
    //var gender: String = ""
    
    var admin: String = ""
    
    var entireUsersModel: EntireUsersModel?
    
    func save() {
        //let queue = DispatchQueue(label: "com.tjuwork.cache")
        queue.async {
            Storage.store(self, in: .documents, as: "user.json")
        }
    }
    
    func load(success: (() -> ())?, failure: (() -> ())?) {
        guard Storage.fileExists("user.json", in: .documents) else {
            DispatchQueue.main.async {
                failure?()
            }
            return
        }
        //let queue = DispatchQueue(label: "com.tjuwork.cache")
        queue.async {
            let user = Storage.retreive("user.json", from: .documents, as: WorkUser.self)
            if let user = user {
                WorkUser.shared = user
                DispatchQueue.main.async {
                    success?()
                }
            } else {
                DispatchQueue.main.async {
                    failure?()
                }
            }
        }
    }
    
    func delete() {
        queue.async {
            print(Storage.remove("user.json", from: .documents))
        }
//        print(Storage.remove("user.json", from: .documents))
        let clientID = WorkUser.shared.clientID
        WorkUser.shared = WorkUser()
        WorkUser.shared.clientID = clientID
    }
    
//    EntireUsersHelper.getEntireUsersInLabels(success: { model in
//    self.entireUsersModel = model
//    }, failure: {
//    
//    })
    
//    func getEntireUsers() {
//        guard self.entireUsersModel != nil else {
//            EntireUsersHelper.getEntireUsersInLabels(success: { model in
//                self.entireUsersModel = model
//                
//            }, failure: {
//                
//            })
//
//            return
//        }
//        return self.entireUsersModel!
//    }
    
    
}


