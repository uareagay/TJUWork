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

        self.tabBar.isTranslucent = false

        let scheduleVC = ScheduleViewController()
        scheduleVC.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "日历")!)
        scheduleVC.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "日历选中")!)
        scheduleVC.title = "日程"
        //one.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let messageVC = MessageViewController()
        messageVC.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "任务")!)
        messageVC.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "任务选中")!)
        messageVC.title = "消息"
        //messageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let conferenceVC = ConferenceViewController()
        conferenceVC.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "会议")!)
        conferenceVC.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "会议选中")!)
        conferenceVC.title = "会议记录"
        
        let contactsBookVC = ContactsBookViewController()
        contactsBookVC.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "电话本")!)
        contactsBookVC.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "电话本选中")!)
        contactsBookVC.title = "电话簿"
        //three.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let personalVC = PersonalInfoViewController()
        personalVC.tabBarItem.image = self.resizedTabBarItemImage(img: UIImage(named: "人")!)
        personalVC.tabBarItem.selectedImage = self.resizedTabBarItemImage(img: UIImage(named: "人选中")!)
        personalVC.title = "个人资料"
        //four.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.setViewControllers([UINavigationController(rootViewController: scheduleVC), UINavigationController(rootViewController: messageVC), UINavigationController(rootViewController: conferenceVC), UINavigationController(rootViewController: contactsBookVC), UINavigationController(rootViewController: personalVC)], animated: true)
    }
    
    func resizedTabBarItemImage(img :UIImage) -> UIImage {
        return UIImage.resizedImage(image: img, scaledToSize: CGSize(width: 32, height: 32))
    }
}
