//
//  SwiftMessagesExtension.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/11.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages


extension SwiftMessages {
    
    static func showSuccessMessage(title: String = "", body: String = "") {
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureContent(title: title, body: body)
            view.button?.isHidden = true
            view.configureTheme(.success)
            return view
        }
    }
    
    static func showErrorMessage(title: String = "", body: String = "") {
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureContent(title: title, body: body)
            view.button?.isHidden = true
            view.configureTheme(.error)
            return view
        }
    }
    
    
}
