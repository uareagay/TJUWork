//
//  DownloadViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/17.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation
import Alamofire


class DownloadViewController: UIViewController {
    
    fileprivate var documentController: UIDocumentInteractionController?
    fileprivate let openBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-50, y: UIScreen.main.bounds.size.height/3, width: 100, height: 45))
        btn.setTitle("打开文件", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        btn.isHidden = true
        return btn
    }()
    
    fileprivate var downloadRequest: DownloadRequest!
    fileprivate var cancelledData: Data?
    fileprivate var isDownloading: Bool = true {
        didSet {
            if isDownloading == true {
                statusBtn.setTitle("暂停", for: .normal)
                if let cancelledData = self.cancelledData {
                    self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: self.destination)
                    
                } else {
                    self.downloadRequest = Alamofire.download(self.downloadURL, headers: nil, to: destination)
                }
                self.downloadRequest.downloadProgress(queue: DispatchQueue.main, closure: { [weak self] progress in
                    self?.progress.setProgress(Float(progress.fractionCompleted), animated: true)
                    print("当前进度：\(progress.fractionCompleted)")
                })
                self.downloadRequest.responseData(queue: DispatchQueue.main, completionHandler: { [weak self] response in
                    self?.handleDownloadResponse(response)
                })
            } else {
                statusBtn.setTitle("继续下载", for: .normal)
                self.downloadRequest.cancel()
            }
        }
    }
    
    fileprivate let statusBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("暂停", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let progress: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = .gray
        progress.progressTintColor = .green
        return progress
    }()
    
    //fileprivate  let destination = Alamofire.DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
    fileprivate let destination: DownloadRequest.DownloadFileDestination = { (_, response) in
        let documentsURL = Storage.getURL(for: .documents)
        let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    fileprivate var downloadedFileURL: URL?
    
    //URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!
    fileprivate var downloadURL: URL! = URL(string: "https://work-alpha.twtstudio.com/file/2018-07-28-5b5be16c0160e.pdf")!
    
    convenience init (fileURL: URL) {
        self.init()
        //self.downloadURL = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!
        self.downloadURL = fileURL
    }
    
    deinit {
        print("deinit DWVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(openBtn)
        self.view.backgroundColor = .white
        self.view.addSubview(statusBtn)
        self.view.addSubview(progress)
        
        progress.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width/2)
            make.top.equalToSuperview().inset(UIScreen.main.bounds.size.height/3)
            make.height.equalTo(6)
        }
        
        statusBtn.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.size.width/4)
            make.centerX.equalToSuperview()
            make.top.equalTo(progress.snp.bottom).offset(50)
            make.height.equalTo(40)
        }
        
        statusBtn.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)
        openBtn.addTarget(self, action: #selector(openFile(_:)), for: .touchUpInside)
        
//        Alamofire.download(URL(string: "https://work-alpha.twtstudio.com/avatar/2018-09-17-5b9e82f98f8fa.jpg")!, headers: nil, to: destination).downloadProgress(queue: DispatchQueue.main, closure: { progress in
//            self.progress.setProgress(Float(progress.fractionCompleted), animated: true)
//            print("当前进度：\(progress.fractionCompleted)")
//        }).responseData(completionHandler: {  [weak self] response in
//            self?.handleDownloadResponse(response)
//        })
        
        self.downloadRequest = Alamofire.download(self.downloadURL, headers: nil, to: destination)
        
        self.downloadRequest.downloadProgress(queue: DispatchQueue.main, closure: { progress in
            self.progress.setProgress(Float(progress.fractionCompleted), animated: true)
            print("当前进度：\(progress.fractionCompleted)")
        })
        
        self.downloadRequest.responseData(completionHandler: { [weak self] response in
            self?.handleDownloadResponse(response)
        })
        
    }
    
}

extension DownloadViewController {
    
    @objc func openFile(_ sneder: UIButton) {
        if documentController?.presentPreview(animated: true) == false {
            documentController?.presentOptionsMenu(from: CGRect(x: 0, y: 0, width: 0, height: 0), in: self.view, animated: true)
        }
    }
    
    @objc func changeStatus(_ sender: UIButton) {
        self.isDownloading = !isDownloading
    }
    
    func handleDownloadResponse(_ response: DownloadResponse<Data>) {
        switch response.result {
        case .success(let data):
            print(response.destinationURL)
            self.downloadURL = response.destinationURL
            print("文件下载完毕: \(response)")
            
            self.documentController = UIDocumentInteractionController(url: response.destinationURL!)
            documentController?.delegate = self
            //documentController?.presentPreview(animated: true)
            //documentController?.presentOpenInMenu(from: CGRect(x: 0, y: 0, width: 0, height: 0), in: self.view, animated: true)
            //documentController?.presentOptionsMenu(from: CGRect(x: 0, y: 0, width: 0, height: 0), in: self.view, animated: true)
            self.statusBtn.removeFromSuperview()
            self.progress.removeFromSuperview()
            self.openBtn.isHidden = false
            
            if documentController?.presentPreview(animated: true) == false {
                documentController?.presentOptionsMenu(from: CGRect(x: 0, y: 0, width: 0, height: 0), in: self.view, animated: true)
            }
        case . failure:
            print("文件下载失败: \(response)")
            self.cancelledData = response.resumeData
        }
    }
    
}

extension DownloadViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    
}
