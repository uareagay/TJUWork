//
//  WorkUser.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

class WorkUser: Codable {
    
    static var shared = WorkUser()
    private init() {}
    
    var token: String?
    
    var username: String = ""
    var password: String = ""
    
    //var ID: String = ""
    //var email: String = ""
    //var picture: String = ""
    //var payNumber: String = ""
    //var wechat: String = ""
    //var phone: String = ""
    //var gender: String = ""
    
    var admin: String = ""
    
    func save() {
        let queue = DispatchQueue(label: "com.tjuwork.cache")
        queue.async {
            Storage.store(self, in: .documents, as: "user.json")
        }
    }
    
    func load(success: (() -> ())?, failure: (() -> ())?) {
        guard Storage.fileExists("user.json", in: .documents) else {
            failure?()
            return
        }
        let queue = DispatchQueue(label: "com.tjuwork.cache")
        queue.async {
            let user = Storage.retreive("user.json", from: .documents, as: WorkUser.self)
            if let user = user {
                WorkUser.shared = user
                success?()
            } else {
                failure?()
            }
        }
    }
    
    func delete() {
        
        
        print(Storage.remove("user.json", from: .documents))
        WorkUser.shared = WorkUser()
    }
    
    
}


