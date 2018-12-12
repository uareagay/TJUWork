//
//  PhoneBook.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/29.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class PhoneBook {
    static let shared = PhoneBook()
    private init() {}
    
//    var items: [ContactUsersData] = []
    var itemDic: [String:String] = [:]
    var itemArrs: [(name: String, phone: String?, academy: String?)] = []
    
    
    func getSearchResult(_ text: String) -> [(name: String, phone: String?, academy: String?)] {
//        return self.items.filter {
//            if $0.realName.contains(text) {
//                return true
//            }
//            if let academy = $0.academy {
//                if academy.contains(text) {
//                    return true
//                } else {
//                    return false
//                }
//            }
//            return false
//        }
        return self.itemArrs.filter {
            if $0.name.contains(text) {
                return true
            }
            if let academy = $0.academy {
                if academy.contains(text) {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
    }
    
    func getPhoneNumber(success: (()->())?, failure: (()->())?) {
        ContactUsersHelper.getContactUsers(success: { model in
            //self.items = model.data
            self.itemArrs = []
            self.itemDic = [:]
            model.data.forEach {
                if let phone = $0.phone, phone.count == 11 {
                    self.itemDic[String($0.uid)] = $0.phone
                }
                
                self.itemArrs.append((name: $0.realName, phone: $0.phone, academy: $0.academy))
                if let officePhone = $0.officePhone {
                    self.itemArrs.append((name: $0.realName + "（办公室）", phone: officePhone, academy: $0.academy))
                }
            }
            success?()
        }, failure: {
            failure?()
        })
    }
    
}
