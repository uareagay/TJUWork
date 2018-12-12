//
//  OutboxSearchModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/22.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct OutboxSearchModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [OutboxSearchData]
}

struct OutboxSearchData: Codable {
    let mid, type: Int
    let author, text: String
    let title: String
    let from: Date
    let to: Date?
}

// MARK: Convenience initializers and mutators

extension OutboxSearchModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(OutboxSearchModel.self, from: data)
        //self = try newJSONDecoder().decode(OutboxSearchModel.self, from: data)
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

extension OutboxSearchData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OutboxSearchData.self, from: data)
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
