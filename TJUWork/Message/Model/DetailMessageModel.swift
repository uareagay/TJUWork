//
//  DetailMessageModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


struct DetailMessageModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: DetailMessageData
}

struct DetailMessageData: Codable {
    let mid, type, title, text: String
    let from: Date
    let to: Date?
    let author, sendUid: String
    let responseBy: String
    let file1, file2, file3, file4: DownloadedFile?
    let file5, file6: DownloadedFile?
    let unit: String
    let respondTo: RespondToMessage?
    let respondedDelete: Int
    
    enum CodingKeys: String, CodingKey {
        case mid, type, title, text, from, to, author
        case sendUid = "send_uid"
        case responseBy = "response_by"
        case file1, file2, file3, file4, file5, file6, unit
        case respondTo = "respond_to"
        case respondedDelete = "responded_delete"
    }
}

struct DownloadedFile: Codable {
    let originName, href, size: String
    
    enum CodingKeys: String, CodingKey {
        case originName = "origin_name"
        case href, size
    }
}

struct RespondToMessage: Codable {
    let mid: String
    let from: Date
    let title, text, author: String
}

// MARK: Convenience initializers and mutators

extension DetailMessageModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(DetailMessageModel.self, from: data)
        //self = try newJSONDecoder().decode(DetailMessageModel.self, from: data)
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


extension DetailMessageData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DetailMessageData.self, from: data)
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

extension DownloadedFile {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DownloadedFile.self, from: data)
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

extension RespondToMessage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RespondToMessage.self, from: data)
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


//
//
//// MARK: Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
