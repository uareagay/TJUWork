//
//  AddScheduleViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/11.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class AddScheduleViewController: UIViewController {
    
    
    fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.text = "编辑内容"
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    var HTMLString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    
    
    
    
    
}


extension AddScheduleViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let richTextVC = RichTextViewController()
        richTextVC.hidesBottomBarWhenPushed = true
        richTextVC.setHTML(self.HTMLString)
        richTextVC.delegate = self
        
        self.navigationController?.pushViewController(richTextVC, animated: true)
        return false
    }
    
}

extension AddScheduleViewController: RichTextTransmitProtocol {
    func transmitText(_ text: String) {
        self.HTMLString = text
        if let attributedString = try? NSAttributedString(data: (text.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.textView.attributedText = attributedString
        }
    }
}
