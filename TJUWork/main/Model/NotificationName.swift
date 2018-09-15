//
//  NotificationName.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/15.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


enum NotificationName: String {
    
    case NotificationRefreshInboxLists
    case NotificationRefreshOutboxLists
    case NotificationRefreshDraftLists
    
}

extension NotificationName {
    
    var name: Notification.Name {
        return Notification.Name(self.rawValue)
    }
    
}
