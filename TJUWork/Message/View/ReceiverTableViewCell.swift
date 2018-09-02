//
//  ReceiverTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/1.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import ObjectiveC
import os_object

@objc protocol AddAndDeleteReceiverProtocol: class {
    @objc optional func deleteReceiverCell(_ indexPath: IndexPath)
    @objc optional func addReceiverCell()
    @objc optional func presentTreeTableView()
}

class ReceiverTableViewCell: UITableViewCell {
    
 
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "收件人："
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    var collectionView: UICollectionView!
    
    weak var delegate: AddAndDeleteReceiverProtocol?
    
    var datas: [String] = ["赵三", "学工部", "校长办公室", "张思", "赵四", "旺财", "天外天", "新闻中心", "王主任", "校医院", "食堂经理"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(70)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 50, height: 32)
        //layout.itemSize = CGSize(width: 60, height: 32)
        layout.footerReferenceSize = CGSize(width: 8, height: 10)
        
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .green
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ReceiverCollectionViewCell.self, forCellWithReuseIdentifier: "ReceiverCollectionViewCell")
        collectionView.register(AddReceiverCollectionViewCell.self, forCellWithReuseIdentifier: "AddReceiverCollectionViewCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(7)
            make.right.equalToSuperview().inset(3)
        }
        
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteCell(_ sender: UIButton) {
//        if let indexPath = objc_getAssociatedObject(sender, &AssociatedKeys.btnKey) as? IndexPath {
//            print(self.datas.remove(at: indexPath.row))
//            self.collectionView.deleteItems(at: [indexPath])
//        }
        
        if let cell = sender.superview?.superview?.superview as? ReceiverCollectionViewCell {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                print(self.datas.remove(at: indexPath.row))
                print(indexPath)
                self.collectionView.deleteItems(at: [indexPath])
                print("okay \(indexPath)")
            }
        }
    }
    
    @objc func addCell(_ sender: UIButton) {
        //delegate?.presentTreeTableView!()
        collectionView.performBatchUpdates({
            datas.append("嘿嘿嘿")
            collectionView.insertItems(at: [IndexPath(item: datas.count - 1, section: 0)])
        }, completion: { _ in
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: true)
        })
    }
    
}


extension ReceiverTableViewCell: UICollectionViewDelegate {
    
    
    
}

extension ReceiverTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else {
            return 1
        }
        return datas.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.section == 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddReceiverCollectionViewCell", for: indexPath) as! AddReceiverCollectionViewCell
            cell.addBtn.addTarget(self, action: #selector(addCell(_:)), for: .touchUpInside)
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCollectionViewCell", for: indexPath) as! ReceiverCollectionViewCell
        //cell = ReceiverCollectionViewCell()
        //collectionView.de
        
        cell.nameLabel.text = datas[indexPath.row]
        
        //objc_setAssociatedObject(cell.deleteBtn, &AssociatedKeys.btnKey, indexPath, .OBJC_ASSOCIATION_COPY_NONATOMIC )
        
        print("fuck\(cell.nameLabel.text)")
        cell.deleteBtn.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
}



