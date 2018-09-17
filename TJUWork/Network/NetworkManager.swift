//
//  NetworkManager.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/30.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import Alamofire


fileprivate let WORK_ROOT_URL = "https://work-alpha.twtstudio.com/api"

struct NetworkManager {
    
    static func getInformation(baseURL: String = WORK_ROOT_URL, url:String, token: String? = nil, parameters: [String:String]? = nil, success: (([String:Any]) -> ())? = nil, failure: ((Error) -> ())? = nil) {
        
        let fullURL = baseURL + url
        
        var headers = HTTPHeaders()
        if let token = WorkUser.shared.token {
            headers["Authorization"] = "bearer \(token)"
        }
        
        Alamofire.request(fullURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    if let dict = data as? [String:Any] {
                        success?(dict)
                    }
                } else {
                    let error = NetworkNotExist(errorString)
                    failure?(error)
                }
            case .failure(let error):
                failure?(error)
            }
        }
        
    }
    
    static func postInformation(baseURL: String = WORK_ROOT_URL, url:String, token: String? = nil, parameters: [String:Any]? = nil, success: (([String:Any]) -> ())? = nil, failure: ((Error) -> ())? = nil) {
        
        
        let fullURL = baseURL + url
        
        var dataDict = [String: Data]()
        var paraDict = [String: String]()
        
        if let dictionary = parameters {
            for item in dictionary {
                if let value = item.value as? UIImage {
                    let data = UIImageJPEGRepresentation(value, 1.0)!
                    dataDict[item.key] = data
                } else if let value = item.value as? String {
                    paraDict[item.key] = value
                }
            }
        }
        
        var headers = HTTPHeaders()
        //headers["User-Agent"] = DeviceStatus.userAgent
        
        if let token = WorkUser.shared.token {
            headers["Authorization"] = "bearer \(token)"
        }
        
        Alamofire.upload(multipartFormData: { formdata in
            for item in dataDict {
                formdata.append(item.value, withName: item.key, fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            for item in paraDict {
                formdata.append(item.value.data(using: .utf8)!, withName: item.key)
            }

        }, to: fullURL, headers: headers, encodingCompletion: { response in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    if let data = response.result.value {
                        if let dict = data as? [String:Any] {
                            success?(dict)
                        }
                    } else {
                        let error = NetworkNotExist(errorString)
                        failure?(error)
                    }
                })
                upload.uploadProgress { progress in
                    
                }
            case .failure(let error):
                failure?(error)
            }
        })
 
    }
    
    struct NetworkNotExist: Error {
        var desc = ""
        var localizedDescription: String {
            return desc
        }
        init(_ desc: String) {
            self.desc = desc
        }
    }
    static let errorString: String = "您似乎已与网络断开连接"
    
}
