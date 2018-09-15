//
//  InboxListModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/13.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


struct InboxListModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    var data: [InboxListData]
}

struct InboxListData: Codable {
    let mid, author, type: String
    let isResponse: Int
    let responseTo, isRead, title, text: String
    let from: Date
    let to: Date?
    let respondedDelete: Int
    
    enum CodingKeys: String, CodingKey {
        case mid, author, type
        case isResponse = "is_response"
        case responseTo = "response_to"
        case isRead = "is_read"
        case title, text, from, to
        case respondedDelete = "responded_delete"
    }
}

// MARK: Convenience initializers and mutators

extension InboxListModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(InboxListModel.self, from: data)
        //self = try newJSONDecoder().decode(InboxListModel.self, from: data)
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

extension InboxListData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InboxListData.self, from: data)
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
