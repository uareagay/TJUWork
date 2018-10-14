//
//  ResponsePeopleModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/12.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct ResponsePeopleModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: ResponsePeopleData
}

struct ResponsePeopleData: Codable {
    let unit: String
    let needRespond, hasResponded: Int
    let finished: [ResponsePeople]
    let unfinished: [ResponsePeople]
    
    enum CodingKeys: String, CodingKey {
        case unit
        case needRespond = "need_respond"
        case hasResponded = "has_responded"
        case finished, unfinished
    }
}

struct ResponsePeople: Codable {
    let name: String
}

// MARK: Convenience initializers and mutators

extension ResponsePeopleModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ResponsePeopleModel.self, from: data)
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

extension ResponsePeopleData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ResponsePeopleData.self, from: data)
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

extension ResponsePeople {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ResponsePeople.self, from: data)
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
