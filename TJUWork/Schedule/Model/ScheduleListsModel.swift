//
//  ScheduleListsModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/25.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


struct ScheduleListsModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [ScheduleListsData]
}

struct ScheduleListsData: Codable {
    let id: Int
    let from, to: Date
    let title, type: String
    let author: String
}

// MARK: Convenience initializers and mutators

extension ScheduleListsModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(ScheduleListsModel.self, from: data)
        //self = try newJSONDecoder().decode(ScheduleListsModel.self, from: data)
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

extension ScheduleListsData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ScheduleListsData.self, from: data)
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
