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
    
    var items: [ContactUsersData] = []
    
    func getSearchResult(_ text: String) -> [ContactUsersData] {
        return self.items.filter { $0.realName.contains(text) }
    }
    
    func getPhoneNumber(success: (()->())?, failure: (()->())?) {
        ContactUsersHelper.getContactUsers(success: { model in
            self.items = model.data
            success?()
        }, failure: {
            failure?()
        })
    }
    
}
