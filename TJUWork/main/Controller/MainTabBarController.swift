//
//  MainTabBarController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class MainTanBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let one = ScheduleViewController()
//        let one = DisplayPeopleViewController()
        one.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "日历")!)
        one.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "日历选中")!)
        one.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let two = MessageViewController()
        two.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "任务")!)
        two.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "任务选中")!)
        two.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let three = SetInfoViewController()
        three.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "人")!)
        three.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "人选中")!)
        three.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let four = ContactsBookViewController()
        four.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "电话本")!)
        four.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "电话本选中")!)
        four.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.setViewControllers([UINavigationController(rootViewController: one), UINavigationController(rootViewController: two), UINavigationController(rootViewController: three), UINavigationController(rootViewController: four)], animated: true)
        
    }
    
    
    func resizedTabBarItemImage(img :UIImage) -> UIImage {
        return UIImage.resizedImage(image: img, scaledToSize: CGSize(width: 32, height: 32))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
