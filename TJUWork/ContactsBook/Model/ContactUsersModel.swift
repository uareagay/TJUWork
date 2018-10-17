//
//  ContactUsersModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/28.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct ContactUsersModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [ContactUsersData]
}

struct ContactUsersData: Codable {
    let uid, realName: String
    let gender, email: String?
    let wechat: String?
    let phone: String?
    let payNumber: String?
    let officePhone, academy: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case realName = "real_name"
        case gender, email, wechat, phone
        case payNumber = "pay_number"
        case academy
         case officePhone = "office_phone"
    }
}

// MARK: Convenience initializers and mutators

extension ContactUsersModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ContactUsersModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ContactUsersData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ContactUsersData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

