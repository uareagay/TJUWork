//
//  EntireLabelsModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/9.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

struct EntireLabelsModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [EntireLabelsData]
}

struct EntireLabelsData: Codable {
    let lid, name, createdUid, type: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case lid, name
        case createdUid = "created_uid"
        case type
        case createdAt = "created_at"
    }
}

// MARK: Convenience initializers and mutators

extension EntireLabelsModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EntireLabelsModel.self, from: data)
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

extension EntireLabelsData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EntireLabelsData.self, from: data)
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
