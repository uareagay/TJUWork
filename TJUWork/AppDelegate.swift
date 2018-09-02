//
//  AppDelegate.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/13.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SwiftMessages

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //self.window?.rootViewController = LoginViewController()
        
        
        //WorkUser.shared.delete()
        WorkUser.shared.load(success: {
            
            AccountManager.getToken(username: WorkUser.shared.name, password: WorkUser.shared.password, success: { token in
                WorkUser.shared.token = token
                
                WorkUser.shared.save()
                print("xixi")
                print(token)
                self.window?.rootViewController = MainTanBarController()
                
                SwiftMessages.show {
                    let view = MessageView.viewFromNib(layout: .cardView)
                    view.configureContent(title: "登录成功", body: "")
                    view.button?.isHidden = true
                    view.configureTheme(.success)
                    return view
                }
                
            }, failure: { errorMsg in
                self.window?.rootViewController = LoginViewController()
                SwiftMessages.show {
                    let view = MessageView.viewFromNib(layout: .cardView)
                    view.configureContent(title: "请重新登录", body: "")
                    view.button?.isHidden = true
                    view.configureTheme(Theme.error)
                    return view
                }
            })
        }, failure: {
            self.window?.rootViewController = LoginViewController()
        })
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

