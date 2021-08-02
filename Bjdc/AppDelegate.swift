//
//  AppDelegate.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
// BjutSoftware806Bjdc.Bjdc

import UIKit
import CoreData
import SwiftDate
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //高德地图
        AMapServices.shared().apiKey = "3ec4096519eb98ebaf864c97a99fb812"
        //Token定时器
        TokenTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector:#selector(UpdateToken), userInfo: nil, repeats: true)
        //每次启动App 对比SessionStringTime 是否过期 若过期则跳转页面重新登录，反之则直接登录
        if let time = realm.objects(SessionRealm.self).first?.SessionAccessTime {
            print("数据库存在Session过期时间",time)
            let date = Date()
            print("date",date)
            print("time",time)
            print("LoginStatues",realm.objects(UserAccountReaml.self).first?.LoginStatues)
            if date > time {
                print("Session过期")
                SessionInvalid = true
            }else{
                print("Session未过期")
                SessionInvalid = false
            }
            if realm.objects(UserAccountReaml.self).first?.LoginStatues == "false" {
                //处于未登录状态
                print("Session过期")
                SessionInvalid = true
            }
        }
        return true
    }
    @objc func UpdateToken() {
            print("Token即将过期正在重新获取")
            accessTokenTimer()
        }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("程序即将终止")
        TokenTimer!.invalidate()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Bjdc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

