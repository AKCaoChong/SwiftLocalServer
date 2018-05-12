//
//  AppDelegate.swift
//  SwiftLocalServer
//
//  Created by thundersoft on 2018/3/8.
//  Copyright © 2018年 thundersoft. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var httpServer: HTTPServer?
    var task = BGTask()
    var bgTimer = Timer()
    var bgLocation = BGLogation()
    var location = CLLocationManager()
    
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.task = BGTask.share()
        if UIApplication.shared.backgroundRefreshStatus == .denied {
            print("应用未开启定位")
        }else if (UIApplication.shared.backgroundRefreshStatus == .restricted){
            print("设备定位未开启")
        }else{
            self.bgLocation = BGLogation.init()
            self.bgLocation.startLocation()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(log), userInfo: nil, repeats: true)
        }
        self.startServer()
        
        return true
    }

    @objc func log() {
        print("loglogloglog....")
    }
    
    func startServer() {
        self.httpServer = HTTPServer()
        self.httpServer?.setPort(35731)
        self.httpServer?.setType("_http._tcp.")
        let rootPath = Bundle.main.path(forResource: "web", ofType: nil)
        self.httpServer?.setDocumentRoot(rootPath)
        self.httpServer?.setConnectionClass(MyHTTPConnection.self)
        do{
            try  self.httpServer?.start()
            print( "请打开以下网址: http://\(HTTPHelper.ipAddress() ?? ""):\(self.httpServer?.listeningPort())/people")
        }catch{
            print("启动失败")
        }
        
    }
    
    func startBgTask() {
        task.beginNewBackgroundTask()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.startBgTask()
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

