//
//  Storage.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation

struct Storage {
    
    enum Directory {
        case documents
        case caches
        //case group
    }
    
    public static func getURL(for directory: Directory) -> URL {
        var searchDirectory: FileManager.SearchPathDirectory
        switch directory {
        case .documents:
            searchDirectory = .documentDirectory
        case .caches:
            searchDirectory = .cachesDirectory
//        case .group:
//            return
        }
        if let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    static func store<T: Encodable>(_ object: T, in directory: Directory, as filename: String, success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        var url = getURL(for: directory)
        var dirs = filename.split(separator: "/")
        
        let encoder = JSONEncoder()
        do {
            for i in 0..<dirs.count {
                if i == dirs.count - 1 {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    url.appendPathComponent(String(dirs[i]), isDirectory: false)
                } else {
                    url.appendPathComponent(String(dirs[i]), isDirectory: true)
                }
            }
            
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            print("storte 失败")
            fatalError(error.localizedDescription)
        }
        print(url.path)
    }
    
    static func retreive<T: Decodable>(_ filename: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func remove(_ filename: String, from directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            return false
        }
        return true
    }
    
    
    
    static func fileExists(_ filename: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    
}
