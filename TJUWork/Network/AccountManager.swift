//
//  AccountManager.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

struct AccountManager {
    
    static func getToken(username: String, password: String, success: ((String) -> ())?, failure: ((String) -> ())?) {
        let para: [String: String] = ["username": username, "password": password]
        
        NetworkManager.postInformation(url: "/login", parameters: para, success: { dic in
            if let data = dic["data"] as? [String: Any], let token = data["token"] as? String {
                success?(token)
            } else {
                failure?("login failure")
            }
        }, failure: { error in
            failure?(error.localizedDescription)
        })
        
    }
    
}
