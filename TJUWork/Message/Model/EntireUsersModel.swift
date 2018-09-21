//
//  EntireUsersModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/8.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

struct EntireUsersModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [EntireUsersData]
}

struct EntireUsersData: Codable {
    let labelID, labelName, type: String
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case labelID = "label_id"
        case labelName = "label_name"
        case type, users
    }
}

struct User: Codable {
    let uid, realName: String
    let email, wechat: String?
    let phone, payNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case realName = "real_name"
        case email, wechat, phone
        case payNumber = "pay_number"
    }
}

// MARK: Convenience initializers and mutators

extension EntireUsersModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EntireUsersModel.self, from: data)
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

extension EntireUsersData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EntireUsersData.self, from: data)
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

extension User {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User.self, from: data)
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

