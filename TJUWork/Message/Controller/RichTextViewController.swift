//
//  RichTextViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/11.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages

class RichTextViewController: ZSSRichTextEditor {
    
    fileprivate var isReply: Bool = false
    
    convenience init(isReply: Bool) {
        self.init()
        self.isReply = isReply
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enabledToolbarItems = [ZSSRichTextEditorToolbarBold, ZSSRichTextEditorToolbarItalic, ZSSRichTextEditorToolbarUnderline, ZSSRichTextEditorToolbarJustifyLeft, ZSSRichTextEditorToolbarJustifyCenter, ZSSRichTextEditorToolbarJustifyRight, ZSSRichTextEditorToolbarRemoveFormat, ZSSRichTextEditorToolbarH1, ZSSRichTextEditorToolbarH2, ZSSRichTextEditorToolbarH3, ZSSRichTextEditorToolbarH4, ZSSRichTextEditorToolbarH5, ZSSRichTextEditorToolbarH6, ZSSRichTextEditorToolbarUnorderedList, ZSSRichTextEditorToolbarOrderedList, ZSSRichTextEditorToolbarIndent, ZSSRichTextEditorToolbarOutdent]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "消息内容"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelEdit(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(saveEdit(_:)))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
}

extension RichTextViewController {
    
    @objc func cancelEdit(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveEdit(_ sender: UIButton) {
        if self.isReply == true {
            let replyVC = self.navigationController?.viewControllers[2] as! ReplyMessageViewController
            replyVC.HTMLString = self.getHTML()
            self.navigationController?.popViewController(animated: true)
        } else {
            let createMessageVC = self.navigationController?.viewControllers[1] as! CreateMessageViewController
            createMessageVC.HTMLString = self.getHTML()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
