//
//  InboxSearchModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/22.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct InboxSearchModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [InboxSearchData]
}

struct InboxSearchData: Codable {
    let mid, title, text, type: String
    let author, responseTo: String
    let from: Date
    let to: Date?
    let isRead: String
    let isResponse, respondedDeleted: Int
    
    enum CodingKeys: String, CodingKey {
        case mid, title, text, type, author
        case responseTo = "response_to"
        case from, to
        case isRead = "is_read"
        case isResponse = "is_response"
        case respondedDeleted = "responded_deleted"
    }
}

// MARK: Convenience initializers and mutators

extension InboxSearchModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(InboxSearchModel.self, from: data)
        //self = try newJSONDecoder().decode(InboxSearchModel.self, from: data)
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

extension InboxSearchData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InboxSearchData.self, from: data)
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
