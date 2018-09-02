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
        
//        var headers = HTTPHeaders()
//        if let token = WorkUser.shared.token {
//            headers["Authorization"] = "bearer \(token)"
//        }
        
        Alamofire.request(fullURL, method: .post, parameters: parameters, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    if let dict = data as? [String:Any] {
                        success?(dict)
                    }
                }
            case .failure: break
                
            }
        }
        
    }
    
}
