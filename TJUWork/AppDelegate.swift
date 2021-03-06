//
//  AppDelegate.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/13.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SwiftMessages
import UserNotificationsUI


let kGtAppId:String = "ZmFLD0KnsT6fwaWOWIt4a7"
let kGtAppKey:String = "Y9nl0CDSSa5a04VGR1ZvE3"
let kGtAppSecret:String = "fh8BbLUIMk5Bn09J2hoCF1"

let semGlobal = DispatchSemaphore(value: 0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
        GeTuiSdk.lbsLocationEnable(true, andUserVerify: true);
        
        // [ GTSdk ]：自定义渠道
        GeTuiSdk.setChannelId("GT-Channel");
        
        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        
        self.registerRemoteNotification()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex6: 0x00518e)], for: .selected)
        let mainVC = MainTanBarController()
        
        mainVC.selectedIndex = 0
        self.window?.rootViewController = mainVC
        
        //WorkUser.shared.delete()
        WorkUser.shared.load(success: {
            semGlobal.wait()
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshConferenceLists.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshPersonalInfo.name, object: nil)
            
            AccountManager.getToken(username: WorkUser.shared.username, password: WorkUser.shared.password, success: { token in
                WorkUser.shared.token = token
                WorkUser.shared.save()
            }, failure: { error in
                if error is NetworkManager.NetworkNotExist {
                    SwiftMessages.showErrorMessage(title: "您似乎已断开与互联网连接", body: "")
                } else {
                    SwiftMessages.showErrorMessage(title: "请重新登录", body: "")
                }
                self.window?.rootViewController?.present(LoginViewController(), animated: true, completion: nil)
            })
        }, failure: {
            SwiftMessages.showErrorMessage(title: "请输入密码", body: "")
            self.window?.rootViewController?.present(LoginViewController(), animated: true, completion: nil)
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
    
    
    
    // MARK: - 远程通知(推送)回调
    
    /** 远程通知注册成功委托 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken_ns = NSData.init(data: deviceToken);    // 转换成NSData类型
        var token = deviceToken_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        token = token.replacingOccurrences(of: " ", with: "")
        
        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token);
    }
    
    /** 远程通知注册失败委托 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n>>>[DeviceToken Error]:%@\n\n",error.localizedDescription);
    }
    
    // MARK: - APP运行中接收到通知(推送)处理 - iOS 10 以下
    
    /** APP已经接收到“远程”通知(推送) - (App运行在后台) */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(userInfo);
        
        completionHandler(UIBackgroundFetchResult.newData);
    }
    


}

// MARK: - GeTuiSdkDelegate

extension AppDelegate: GeTuiSdkDelegate {
    
    /** SDK启动成功返回cid */
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        // [4-EXT-1]: 个推SDK已注册，返回clientId
        NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
        
        WorkUser.shared.clientID = clientId
//        NetworkManager.postInformation(url: "/user/device", token: WorkUser.shared.token, parameters: ["cid": clientId], success: { dic in
//
//        }, failure: { error in
//
//        })
    }
    
    /** SDK遇到错误回调 */
    func geTuiSdkDidOccurError(_ error: Error!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription);
    }
    
    /** SDK收到sendMessage消息回调 */
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId),result=\(result)";
        NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n",msg);
    }
    /** SDK通知收到个推推送的透传消息 */
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        var payloadMsg = "";
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!;
        }
        
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)";
        
        NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n",msg);
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if offLine == false {
            let rvc = UIAlertController(title: nil, message: "有一条新消息", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "稍后", style: .default) { action in
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshConferenceLists.name, object: nil)
                
            }
            let checkAction = UIAlertAction(title: "查看", style: .default) { action in
                self.jumpPage()
            }

            rvc.addAction(cancelAction)
            rvc.addAction(checkAction)
            self.window?.rootViewController?.present(rvc, animated: true, completion: nil)
        } else {
            jumpPage()
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.sound,.alert]);
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo);
        print(response.notification.request.content.userInfo["payload"])
        
        completionHandler();
    }
  
}


// MARK: - 用户通知(推送) _自定义方法

extension AppDelegate {
    
    func registerRemoteNotification() {
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue;
        if systemVer >= 10.0 {
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self;
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        print("注册通知成功") //点击允许
                    } else {
                        print("注册通知失败") //点击不允许
                    }
                })
                
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                if #available(iOS 8.0, *) {
                    let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(userSettings)
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
            };
        }else if systemVer >= 8.0 {
            if #available(iOS 8.0, *) {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }else {
            if #available(iOS 7.0, *) {
                UIApplication.shared.registerForRemoteNotifications(matching: [.alert, .sound, .badge])
            }
        }
    }

}

extension AppDelegate {
    func jumpPage() {
//        let rvc = UIAlertController(title: nil, message: "有一条新消息", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "稍后", style: .default, handler: nil)
//        let checkAction = UIAlertAction(title: "查看", style: .default) { action in
//            if let rootVC = self.window?.rootViewController as? UITabBarController {
//                if let navigationVC = rootVC.selectedViewController as? UINavigationController, let messageVC = navigationVC.viewControllers.first as? MessageViewController {
//
//                    messageVC.currentMenuType = .inbox
//                    messageVC.menuView.hideMenuView()
//                    messageVC.isSelecting = false
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//                } else {
//                    rootVC.selectedIndex = 1
//                    if let navigationVC = rootVC.selectedViewController as? UINavigationController, let messageVC = navigationVC.viewControllers.first as? MessageViewController {
//
//                        messageVC.currentMenuType = .inbox
//                        messageVC.menuView.hideMenuView()
//                        messageVC.isSelecting = false
//                        NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//                    }
//
//                }
//            }
//        }
//
//        rvc.addAction(cancelAction)
//        rvc.addAction(checkAction)
//        self.window?.rootViewController?.present(rvc, animated: true, completion: nil)
        
        let mainVC = MainTanBarController()
        mainVC.selectedIndex = 1
        self.window?.rootViewController = mainVC
        
//        if let rootVC = self.window?.rootViewController as? UITabBarController {
//            rootVC.selectedIndex = 1
//            if let navigationVC = rootVC.selectedViewController as? UINavigationController {
//
//                rootVC.selectedViewController = UINavigationController(rootViewController: MessageViewController())
////                messageVC.currentMenuType = .inbox
////                messageVC.menuView.hideMenuView()
////                messageVC.isSelecting = false
////                NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//            }
//
//        }
//            else {
//                rootVC.selectedIndex = 1
//                if let navigationVC = rootVC.selectedViewController as? UINavigationController, let messageVC = navigationVC.viewControllers.first as? MessageViewController {
//
//                    messageVC.currentMenuType = .inbox
//                    messageVC.menuView.hideMenuView()
//                    messageVC.isSelecting = false
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//                }
//
//            }

        
    }
    
}
