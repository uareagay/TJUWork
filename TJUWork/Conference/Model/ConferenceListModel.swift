//
//  ConferenceListModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/11/3.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation

struct ConferenceListModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [ConferenceItem]
}

struct ConferenceItem: Codable {
    let title, sendUid, place, text: String
    let author, mid: String
    let to: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case sendUid = "send_uid"
        case place, text, to, author, mid
    }
}

// MARK: Convenience initializers and mutators

extension ConferenceListModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(ConferenceListModel.self, from: data)
        //self = try newJSONDecoder().decode(ConferenceListModel.self, from: data)
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

extension ConferenceItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ConferenceItem.self, from: data)
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
