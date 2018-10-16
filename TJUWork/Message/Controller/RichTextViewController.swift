//
//  RichTextViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/11.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import SwiftMessages

protocol RichTextTransmitProtocol: class {
    func transmitText(_ text: String)
}

class RichTextViewController: ZSSRichTextEditor {
    
    fileprivate var isReply: Bool = false
    
    weak var delegate: RichTextTransmitProtocol?
    
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
        let alertVC = UIAlertController(title: "取消此次更改吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        let saveChangeAction = UIAlertAction(title: "保存", style: .default) { _ in
            self.delegate?.transmitText(self.getHTML())
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveChangeAction)
        
        self.present(alertVC, animated: true)
    }
    
    @objc func saveEdit(_ sender: UIButton) {
//        if self.isReply == true {
//            let replyVC = self.navigationController?.viewControllers[2] as! ReplyMessageViewController
//            replyVC.HTMLString = self.getHTML()
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            let createMessageVC = self.navigationController?.viewControllers[1] as! CreateMessageViewController
//            createMessageVC.HTMLString = self.getHTML()
//            self.navigationController?.popViewController(animated: true)
//        }
        delegate?.transmitText(self.getHTML())
        self.navigationController?.popViewController(animated: true)
    }
    
}
