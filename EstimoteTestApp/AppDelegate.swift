//
//  AppDelegate.swift
//  EstimoteTestApp
//
//  Created by fnord on 1/11/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, ESTDeviceManagerDelegate {

    var window: UIWindow?
    
    let beaconManager = ESTBeaconManager()
    var deviceManager = ESTDeviceManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.beaconManager.delegate = self
        
        // add this below:
        self.beaconManager.requestAlwaysAuthorization()
        
        ESTConfig.setupAppID("lighthouse-ehj", andAppToken: "8d3827292d20b0169959be6dc1b707f1")
        
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID,
            major: 30321, minor: 46836, identifier: "monitored region"))
        
        UIApplication.shared.registerUserNotificationSettings(
            UIUserNotificationSettings(types: .alert, categories: nil))
        
        // Override point for customization after application launch.
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
    
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice]) {
        print(devices)
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            "Your gate closes in 47 minutes. " +
            "Current security wait time is 15 minutes, " +
            "and it's a 5 minute walk from security to the gate. " +
        "Looks like you've got plenty of time!"
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        print(state.rawValue)
    }


}

