//
//  ReadPeopleModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/12.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct ReadPeopleModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: ReadPeopleData
}

struct ReadPeopleData: Codable {
    let needRead, hasRead: Int
    let finished: [ReadPeople]
    let unfinished: [ReadPeople]
    
    enum CodingKeys: String, CodingKey {
        case needRead = "need_read"
        case hasRead = "has_read"
        case finished, unfinished
    }
}

struct ReadPeople: Codable {
    let name, uid: String
    let phone: String?
}

// MARK: Convenience initializers and mutators

extension ReadPeopleModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReadPeopleModel.self, from: data)
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

extension ReadPeopleData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReadPeopleData.self, from: data)
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

extension ReadPeople {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReadPeople.self, from: data)
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
