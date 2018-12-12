//
//  DraftListModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/12.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


struct DraftListModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    var data: DraftData
}

struct DraftData: Codable {
    var data: [DraftListData]
}

struct DraftListData: Codable {
    let did: Int
    let title, type, text: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case did, title, type, text
        case createdAt = "created_at"
    }
}

// MARK: Convenience initializers and mutators

extension DraftListModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DraftListModel.self, from: data)
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

extension DraftData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DraftData.self, from: data)
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

extension DraftListData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DraftListData.self, from: data)
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
