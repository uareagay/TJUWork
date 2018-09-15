//
//  WorkCalendarModel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


struct WorkCalendarModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    var data: [WorkCalendarData]
}

struct WorkCalendarData: Codable {
    let mid: String
    let author, title, text: String
    let from: Date
    var to: Date
    let precent: String
    let isIndividualFinished: Int
    let isLabelsFinished: [IsLabelsFinished]
    
    enum CodingKeys: String, CodingKey {
        case mid, author, title, text, from, to, precent
        case isIndividualFinished = "is_individual_finished"
        case isLabelsFinished = "is_labels_finished"
    }
}

struct IsLabelsFinished: Codable {
    let name: String
    let isResponse: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case isResponse = "is_response"
    }
}

// MARK: Convenience initializers and mutators

extension WorkCalendarModel {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        self = try decoder.decode(WorkCalendarModel.self, from: data)
        //self = try newJSONDecoder().decode(WorkCalendarModel.self, from: data)
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

extension WorkCalendarData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WorkCalendarData.self, from: data)
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

extension IsLabelsFinished {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IsLabelsFinished.self, from: data)
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



